FROM golang:alpine AS builder

WORKDIR /app
COPY . .
COPY . .

ENV GO111MODULE=on
RUN go mod download

RUN CGO_ENABLED=0 go build -ldflags="-w -s" -o override
RUN CGO_ENABLED=0 go build -ldflags="-w -s" -o override

FROM alpine:latest

RUN apk --no-cache add ca-certificates

COPY --from=builder /app/override /usr/local/bin/
COPY config.json.example /app/config.json
RUN apk --no-cache add ca-certificates

COPY --from=builder /app/override /usr/local/bin/
COPY config.json.example /app/config.json

WORKDIR /app
VOLUME /app

EXPOSE 8080
CMD ["override"]