package main

import (
	"context"
	"os"
	"time"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/kinesis"
)

var StreamName = "sample-data-stream"
var ShardId = "shardId-000000000000"
var BatchSize = int32(10)

func main() {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})
	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix

	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatal().Err(err).Msg("Error creating the credentials")
		return
	}

	kinesisClient := kinesis.NewFromConfig(cfg)

	iterator, err := kinesisClient.GetShardIterator(context.TODO(), &kinesis.GetShardIteratorInput{
		ShardId:           &ShardId,
		StreamName:        &StreamName,
		ShardIteratorType: "LATEST",
	})
	if err != nil {
		log.Fatal().Err(err).Msg("Error getting the iterator")
		return
	}

	currentIterator := iterator.ShardIterator

	for {
		output, err := kinesisClient.GetRecords(context.TODO(), &kinesis.GetRecordsInput{
			ShardIterator: currentIterator,
			Limit:         &BatchSize,
		})
		if err != nil {
			log.Fatal().Err(err).Msg("Error getting the iterator")
			return
		}

		for _, record := range output.Records {
			log.Info().Msg("Received on partition key " + *record.PartitionKey + ": " + string(record.Data))
		}

		currentIterator = output.NextShardIterator

		time.Sleep(2 * time.Second)
		log.Info().Msg("Waiting...")
	}
}
