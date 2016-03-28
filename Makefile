.PHONY: all build

all: build

build:
	docker build -t mantl-kibana --rm .
