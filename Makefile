include .env

f :=
art:
	@cat .config/scripts/arts/${f}.txt
	@echo

echo-system:
	@make art f=system

build:
	@docker compose -f ${DOCKER_COMPOSE_FILE} build --no-cache

build-cache:
	@docker compose -f ${DOCKER_COMPOSE_FILE} build

up:
	@make echo-system
	@docker compose -f ${DOCKER_COMPOSE_FILE} up -d

watch:
	@make echo-system
	@docker compose -f ${DOCKER_COMPOSE_FILE} up

down:
	@docker compose -f ${DOCKER_COMPOSE_FILE} down

restart:
	@make down
	@make up

a :=
logs:
	@docker logs -f $(a)

logs-app:
	@make logs a=peteco-app

logs-server:
	@make logs a=peteco-server

a :=
c :=
exec:
	@docker compose -f ${DOCKER_COMPOSE_FILE} exec $(a) $(c)

npm-prune:
	@make exec a=peteco-app c="npm prune"

npm-build:
	@make exec a=peteco-app c="npm run build"

b ?=
npm-install:
	@make exec a=peteco-app c="npm install $(b)"

lint:
	@make exec a=peteco-app c="npm run lint"

in:
	@bash .config/scripts/in.sh

m :=
module:
	@bash .config/scripts/create_module.sh $(m)

update:
	@make npm-install
	@make npm-build
	@make npm-prune
	@make restart

up ?=
watch ?=
install:
	@make build
	@echo
	@echo "Enrollment Web fully installed!"
	@echo
ifdef up
	@make up
else ifdef watch
	@make watch
endif
