data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = "bin/lambda_sqs_partial_return"
  output_path = "lambda-sqs-partial-return.zip"
}


data "aws_iam_policy_document" "allow_save_logs" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${var.region}:${var.account_id}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/${aws_lambda_function.lambda_sqs_partial_return.function_name}:*"
    ]
  }
}


data "aws_iam_policy_document" "allow_consume_sqs_incoming_events" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = ["arn:aws:sqs:*:${var.account_id}:${aws_sqs_queue.sqs_incoming_events.name}"]
  }
}

