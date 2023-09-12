# Define a imagem base para a construção, usando a imagem Alpine do Golang 1.19.13.
FROM golang:1.19.13-alpine AS builder

# Define o diretório de trabalho no contêiner para a construção.
WORKDIR /go/src/app

# Copia todo o conteúdo do diretório local para o diretório de trabalho no contêiner.
COPY . .

# Inicializa um módulo Go (se já não existir) e compila o código-fonte em um executável chamado 'server'.
RUN go mod init && \
    go build -o server .

# Define uma nova etapa baseada em uma imagem vazia ("scratch") para criar uma imagem mínima.
FROM scratch

# Copia o executável 'server' gerado na etapa anterior para o diretório de trabalho no contêiner final.
COPY --from=builder /go/src/app/server /go/src/app/server

# Expõe a porta 80 para que o contêiner possa receber conexões na porta 80.
EXPOSE 80

# Define o comando a ser executado quando o contêiner for iniciado, que é o executável 'server'.
CMD ["/go/src/app/server"]
