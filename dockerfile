FROM golang:1.19-alpine AS builder
RUN apk upgrade --no-cache --force
RUN apk add --update build-base make git

WORKDIR #{Build.Repository.LocalPath}#
COPY go.mod go.sum .
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/azdoexporter .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /app/azdoexporter /app/azdoexporter
EXPOSE 8080
ENTRYPOINT ["/app/azdoexporter"]
