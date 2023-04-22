package main

import (
	"context"
	"math"
	"os"
	"strconv"
	"time"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/kinesis"
)

var StreamName = "sample-data-stream"

func main() {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})
	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix

	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatal().Err(err).Msg("Error creating the credentials:")
		return
	}

	kinesisClient := kinesis.NewFromConfig(cfg)
	for i := 0; i < math.MaxInt; i++ {
		data := "Data sent: " + strconv.Itoa(i) + " " + time.Now().Format("02/01/2006 15:04:05")
		partitionKey := strconv.Itoa(i)
		record := &kinesis.PutRecordInput{
			Data:         []byte(data),
			PartitionKey: &partitionKey,
			StreamName:   &StreamName,
		}

		output, err := kinesisClient.PutRecord(context.TODO(), record)
		if err != nil {
			log.Fatal().Err(err).Msg("Error sending data to stream: " + StreamName)
			return
		}

		log.Info().Msg("Sented data into shard: " + *output.ShardId)
		time.Sleep(500 * time.Microsecond)
	}
}
