.PHONY: all build

DOCKER  = docker
REPO    = ciscocloud
NAME    = mantl-kibana

all: build

build:
	$(DOCKER) build -t $(NAME) --rm .

tag: build
	$(DOCKER) tag $(NAME) $(REPO)/$(NAME):edge

push: tag
	$(DOCKER) push $(REPO)/$(NAME):edge
