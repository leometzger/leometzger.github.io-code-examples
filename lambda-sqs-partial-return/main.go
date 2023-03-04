package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type MessageFailure struct {
	ItemIdentifier string `json:"itemIdentifier"`
}

type BatchItemFailures struct {
	BatchItemFailures []MessageFailure `json:"batchItemFailures"`
}

func handler(ctx context.Context, event events.SQSEvent) (string, error) {
	var failures BatchItemFailures

	for _, message := range event.Records {
		time.Sleep(200 * time.Millisecond)
		fmt.Println(message.Body)

		if rand.Intn(10) < 2 {
			fmt.Println("Failed", message.MessageId)

			failure := MessageFailure{ItemIdentifier: message.MessageId}
			failures.BatchItemFailures = append(
				failures.BatchItemFailures,
				failure,
			)
		}
	}

	fmt.Println("Total failed", len(failures.BatchItemFailures))

	response, err := json.Marshal(failures)
	if err != nil {
		log.Fatal("Error marshaling BatchItemFailures")
	}

	return string(response), nil
}

func main() {
	lambda.Start(handler)
}
