REPO = ciscocloud
VERSION = 4.3.2

.PHONY: all build

all: build

build:
	docker build -t ${REPO}/mantl-kibana:$(VERSION) --rm .

tag:
	docker tag $(REPO)/mantl-kibana:$(VERSION) $(REPO)/mantl-kibana:latest

release: tag
	docker push $(REPO)/mantl-kibana:$(VERSION)
	docker push $(REPO)/mantl-kibana:latest
