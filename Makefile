# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sbakhit <sbakhit@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/27 19:36:02 by sbakhit           #+#    #+#              #
#    Updated: 2025/04/29 19:28:23 by sbakhit          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DOCKER_COMPOSE=docker compose

DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

build:
	mkdir -p ${HOME}/data/mysql
	mkdir -p ${HOME}/data/wordpress
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up --build -d
	
down:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down
	
kill:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) kill
	
clean:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
	rm -r /home/${USER}/data/mysql
	rm -r /home/${USER}/data/wordpress
	docker system prune -a -f

restart: clean build

.PHONY: kill build down clean restart