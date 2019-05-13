TAG ?= latest

.PHONY: build
build:
	docker build -t syucream/docker-cloudmapper:${TAG} . --no-cache=true

.PHONY: push
push: build
	docker push syucream/docker-cloudmapper
