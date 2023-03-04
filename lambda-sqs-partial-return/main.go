package main

import (
	"context"
	"fmt"
	"math/rand"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context, event events.SQSEvent) (events.SQSEventResponse, error) {
	failures := events.SQSEventResponse{}

	for _, message := range event.Records {
		// Simulação de um processamento
		fmt.Println("Processing message:", message.Body)
		time.Sleep(200 * time.Millisecond)

		if rand.Intn(10) < 2 {
			fmt.Println("Failed", message.MessageId)
			failures.BatchItemFailures = append(failures.BatchItemFailures, events.SQSBatchItemFailure{
				ItemIdentifier: message.MessageId,
			})
		}
	}

	fmt.Println("Total failed", len(failures.BatchItemFailures))

	// Apenas as mensagens falhadas voltarão para a fila para serem reprocessadas
	return failures, nil
}

func main() {
	lambda.Start(handler)
}
