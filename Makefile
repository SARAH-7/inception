# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sbakhit <sbakhit@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/27 19:36:02 by sbakhit           #+#    #+#              #
#    Updated: 2025/05/27 17:22:06 by sbakhit          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DOCKER_COMPOSE = docker compose
COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/${USER}/data

all: build up

build:
	@mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress $(DATA_DIR)/redis
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up --build -d

up:
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up -d

down:
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

clean: down
	- docker rmi -f $(shell docker images -q)
	@sudo rm -rf $(DATA_DIR)

fclean: clean
	@docker system prune -af --volumes

re: fclean build

.PHONY: build up down clean fclean re