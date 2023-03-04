resource "aws_iam_policy" "allow_logs_policy" {
  name        = "AllowLogsPolicy"
  description = "Allow lambda to save logs on cloudwatch"
  policy      = data.aws_iam_policy_document.allow_save_logs.json
}


resource "aws_iam_policy" "allow_consume_sqs_incoming_events_policy" {
  name        = "AllowConsumeSQSIncomingEvents"
  description = "Allow lambda to save logs on cloudwatch"
  policy      = data.aws_iam_policy_document.allow_consume_sqs_incoming_events.json
}


resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_iam_role_policy_attachment" "attach_logs_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.allow_logs_policy.arn

  depends_on = [
    aws_lambda_function.lambda_sqs_partial_return,
    aws_iam_policy.allow_logs_policy
  ]
}


resource "aws_iam_role_policy_attachment" "attach_consume_sqs_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.allow_consume_sqs_incoming_events_policy.arn

  depends_on = [
    aws_lambda_function.lambda_sqs_partial_return,
    aws_iam_policy.allow_consume_sqs_incoming_events_policy
  ]
}

resource "aws_lambda_function" "lambda_sqs_partial_return" {
  filename      = "lambda-sqs-partial-return.zip"
  function_name = "lambda-sqs-partial-return"
  role          = aws_iam_role.iam_for_lambda.arn

  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "go1.x"
  handler          = "lambda_sqs_partial_return"
}


resource "aws_sqs_queue" "sqs_incoming_events_dlq" {
  name                      = "sqs-incoming-events-dlq"
  max_message_size          = 2048
  message_retention_seconds = 86400
}


resource "aws_sqs_queue" "sqs_incoming_events" {
  name                      = "sqs-incoming-events"
  max_message_size          = 2048
  message_retention_seconds = 86400
  redrive_policy = jsonencode({
    maxReceiveCount     = 1
    deadLetterTargetArn = aws_sqs_queue.sqs_incoming_events_dlq.arn
  })
}

resource "aws_lambda_event_source_mapping" "incoming_events_to_ingest" {
  event_source_arn                   = aws_sqs_queue.sqs_incoming_events.arn
  function_name                      = aws_lambda_function.lambda_sqs_partial_return.arn
  batch_size                         = 10
  maximum_batching_window_in_seconds = 30
  function_response_types            = ["ReportBatchItemFailures"]
}
