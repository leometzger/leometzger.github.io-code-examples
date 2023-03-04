.PHONY: build 
build:
	GOOS=linux GOARCH=amd64 go build -o "bin/lambda_sqs_partial_return" main.go

.PHONY: build 
init:
	terraform init
	terraform fmt
	terraform validate

.PHONY: validate
validate:
	terraform validate

.PHONY: deploy
deploy:
	make build
	terraform apply

.PHONY: destroy
destroy:
	terraform destroy


