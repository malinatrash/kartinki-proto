# Указываем переменные
PROTOC = protoc
PROTOC_GEN_GO = $(GOPATH)/bin/protoc-gen-go
PROTOC_GEN_GRPC_GO = $(GOPATH)/bin/protoc-gen-grpc-go
PROTOC_GEN_GRPC_GATEWAY = $(GOPATH)/bin/protoc-gen-grpc-gateway
PROTOC_GEN_OPENAPIV2 = $(GOPATH)/bin/protoc-gen-openapiv2

PROTO_FILES = $(wildcard auth/v1/*.proto)
OUT_DIR = gen

# Цель по умолчанию
all: generate

# Генерация Go-кода для gRPC
generate:
	@echo "Generating Go code from Proto files..."
	@protoc -I . -I ./googleapis \
		--go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		--grpc-gateway_out=. --grpc-gateway_opt=paths=source_relative \
		auth/v1/auth.proto

# Генерация OpenAPI документации
openapi: $(PROTO_FILES)
	@echo "Generating OpenAPI specification..."
	$(PROTOC) -I . -I ./googleapis \
		--openapiv2_out=openapi \
		--openapiv2_opt logtostderr=true \
		$^

# Установить зависимости (плагины protoc)
install-deps:
	@echo "Installing dependencies..."
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-grpc-go@latest

# Очистить сгенерированные файлы
clean:
	@echo "Cleaning generated files..."
	@rm -rf gen/*

# Цели для Makefile
.PHONY: all generate openapi install-deps clean