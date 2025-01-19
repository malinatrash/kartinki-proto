.PHONY: gen clean

gen: clean
	mkdir -p gen/go
	protoc --go_out=./gen/go \
		--go_opt=paths=source_relative \
		--go-grpc_out=./gen/go \
		--go-grpc_opt=paths=source_relative \
		--grpc-gateway_out=./gen/go \
		--grpc-gateway_opt=paths=source_relative \
		./auth_service/v1/*.proto

clean:
	rm -rf gen/go/*