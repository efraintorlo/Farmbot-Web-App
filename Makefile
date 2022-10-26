SHELL := /bin/bash
#-----------------------------------------------------
#           __  __       _         __ _ _
#          |  \/  | __ _| | _____ / _(_) | ___
#          | |\/| |/ _  | |/ / _ \ |_| | |/ _ \
#          | |  | | (_| |   <  __/  _| | |  __/
#          |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
#
#-----------------------------------------------------
#   Makefile for Farmbot Installation/Uninstallation
#-----------------------------------------------------
#	Author:      efrain.tor.lo
#	Email:       efrain.tor.lo@gmail.com
#	Repository:  https://???
#	Description: This Makefile is useful to:
#	              > Install Farmbot on Premise
#                 > Destroy Farmbot on Premise
#   Dependencies: 
#                 > Docker
#--------------------------------------------------------------------
# Variables
#--------------------------------------------------------------------
DOCKER_COMPOSE ?= docker-compose


#--------------------------------------------------------------------
.PHONY: default install up down start stop log logs clean clear help

default: help


install:
	$(DOCKER_COMPOSE) run web gem install bundler:2.1.4
	$(DOCKER_COMPOSE) run web bundle install
	$(DOCKER_COMPOSE) run web npm install
	$(DOCKER_COMPOSE) run web bundle exec rails db:create db:migrate
	$(DOCKER_COMPOSE) run web rake keys:generate
	$(DOCKER_COMPOSE) run web rake assets:precompile

start: up

stop:
	$(DOCKER_COMPOSE) stop

up:
	$(DOCKER_COMPOSE) up -d
	
down:
	$(DOCKER_COMPOSE) down

log: logs

logs:
	$(DOCKER_COMPOSE) logs -f --tail=100

clean: down
	sudo rm -rf docker_volumes/*
	sudo rm -rf node_modules/*

clear: clean
	$(DOCKER_COMPOSE) down --rmi='all'	

#-----------------------------------------------------------------
# -----------------------------
# Some styles and colors to be
# used in Terminal outputs
# -----------------------------
REDC = \033[31m
BOLD = \033[1m
GREENC = \033[32m
UNDERLINE = \033[4m
ENDC = \033[0m
# -----------------------------

# -------------------------------------------------------------------------------------------------------------------------
help:
	@echo "------------------------------------------------------"
	@echo -e "               $(UNDERLINE)$(REDC) < FarmBot Installer >$(ENDC)"
	@echo -e "                   $(GREENC) Makefile Menu$(ENDC)"
	@echo "------------------------------------------------------"
	@echo "Please use 'make <target>' where target is one of:"
	@echo
	@echo -e "$(REDC)default$(ENDC)    > Default Action: '$(GREENC)help$(ENDC)'"
	@echo
	@echo -e "$(REDC)install$(ENDC)    > Create all containers"
	@echo
	@echo -e "$(REDC)up$(ENDC)         > Create/Up Containers"
	@echo
	@echo -e "$(REDC)down$(ENDC)       > Stop and Destroy containers"
	@echo
	@echo -e "$(REDC)start$(ENDC)      > Start Containers"
	@echo
	@echo -e "$(REDC)stop$(ENDC)       > Stop Containers"
	@echo
	@echo -e "$(REDC)clean$(ENDC)      > Stop and Destroy containers"
	@echo
	@echo -e "$(REDC)clear$(ENDC)      > Stop, destroy container and images"
	@echo
	@echo -e "$(REDC)logs$(ENDC)       > Show and follow containers logs"
	@echo
	@echo -e "$(REDC)help$(ENDC)       > Show this help menu"
	@echo "------------------------------------------------------"
# -------------------------------------------------------------------------------------------------------------------------