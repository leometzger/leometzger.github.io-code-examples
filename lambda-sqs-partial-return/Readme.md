# Lambda SQS com retorno parcial (infra AWS)

## Pré requisitos

- Ter terraform instalado
- Ter make funcionando na máquina

## Rodar

1. Para iniciar o template terraform e baixar as dependências

```
make init
```

2. Fazer deploy do terraform

```
make deploy
```

3. Informar o account_id para fazer o deploy
4. Verificar o deploy na região us-east-1
