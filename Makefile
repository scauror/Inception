NAME=inception
COMPOSE=srcs/docker-compose.yml

all: ${NAME}

${NAME}:
	mkdir -p /home/dolphin/data/wordpress /home/dolphin/data/mysql
	sudo docker-compose -f $(COMPOSE) up -d --build

down:
	sudo docker-compose -f $(COMPOSE) down

clean:
	sudo docker-compose -f $(COMPOSE) down -v

fclean: clean
	sudo docker system prune --force --volumes --all
	sudo rm -rf ~/data

re: down all

logs:
	echo "---------- MARIADB -----------\n"
	sudo docker-compose -f $(COMPOSE) logs mariadb
	echo "\n-------- WORDPRESS ----------\n"
	sudo docker-compose -f $(COMPOSE) logs wordpress
	echo "\n---------- NGINX ------------\n"
	sudo docker-compose -f $(COMPOSE) logs nginx