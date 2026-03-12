# Estágio de build
FROM golang:1.21-alpine AS builder

# Instala o Git (necessário para baixar dependências)
RUN apk add --no-cache git

WORKDIR /app
COPY . .

# Baixa as dependências
RUN go mod download

# Compila o binário
RUN CGO_ENABLED=0 GOOS=linux go build -o proxy

# Estágio final (imagem menor)
FROM alpine:latest

# Instala certificados CA para HTTPS
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copia o binário compilado do estágio builder
COPY --from=builder /app/proxy .

# Porta que o proxy vai usar (pode ser alterada via variável de ambiente)
EXPOSE 1080

# Comando para rodar o proxy
CMD ["./proxy"]
