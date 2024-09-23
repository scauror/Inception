NAME=inception

${NAME}:
	@mkdir -p ~/data/wordpress ~/data/mariadb
	sudo docker-compose -f srcs/docker-compose.yml up -d --build
#     sleep 15
#     make logs

all: ${NAME}

down:
	sudo docker-compose -f srcs/docker-compose.yml down

clean:
	sudo docker-compose -f srcs/docker-compose.yml down -v

fclean: clean
	sudo docker system prune --force --volumes --all
	sudo rm -rf ~/data

re: down all

logs:
	@echo "---------- MARIADB -----------\n"
	@sudo docker-compose -f srcs/docker-compose.yml logs mariadb
	@echo "\n-------- WORDPRESS ----------\n"
	@sudo docker-compose -f srcs/docker-compose.yml logs wordpress
	@echo "\n---------- NGINX ------------\n"
	@sudo docker-compose -f srcs/docker-compose.yml logs nginx