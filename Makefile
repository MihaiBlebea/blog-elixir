IMAGE := elixir-blog
TAG := 0.1

build-up: build up

build:
	docker-compose build --no-cache

up:
	docker-compose up -d

down:
	docker-compose down

build-blog:
	docker build -t ${IMAGE}:${TAG} .

run-blog:
	docker run -d --rm --name ${IMAGE} --env-file=.env -p 8099:8099 ${IMAGE}:${TAG}

remove-blog:
	docker stop ${IMAGE} && docker rm ${IMAGE}