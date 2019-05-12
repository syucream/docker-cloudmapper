.PHONY: build
build:
	docker build -t syucream/docker-cloudmapper .

.PHONY: push
push: build
	docker push syucream/docker-cloudmapper
