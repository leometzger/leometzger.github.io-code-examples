#!/bin/bash

REGION="us-east-1"
ACCOUNT_ID="971064939130"

for i in {1..10}
do
	echo "sending $i"
	aws sqs send-message \
		--queue-url "https://sqs.$REGION.amazonaws.com/$ACCOUNT_ID/sqs-incoming-events" \
		--message-body "message-$i" >> /dev/null
done
