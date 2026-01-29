COMPOSE_FILE=./srcs/docker-compose.yml

all: run

run:
	docker compose -f $(COMPOSE_FILE) up --build -d

stop:
	docker compose -f $(COMPOSE_FILE) down

fclean: stop
	docker system prune -a --volumes -f
	docker volume rm -f srcs_dbdata srcs_wpdata

re: fclean run
