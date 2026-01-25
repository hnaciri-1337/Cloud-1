COMPOSE_FILE=./srcs/docker-compose.yml

all: run

run:
	mkdir -p ~/data
	mkdir -p ~/data/mysql
	mkdir -p ~/data/wordpress
	docker compose -f $(COMPOSE_FILE) up --build -d

stop:
	docker compose -f $(COMPOSE_FILE) down

fclean: stop
	docker system prune -a
	sudo rm -rf ~/data
	docker volume rm -f srcs_dbdata srcs_wpdata

re: fclean run
