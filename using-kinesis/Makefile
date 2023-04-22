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
	terraform apply

.PHONY: destroy
destroy:
	terraform destroy

.PHONY: produce
produce:
	go run producer/main.go

.PHONY: consume
consume:
	go run consumer/main.go
