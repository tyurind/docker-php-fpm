#!/bin/bash


##
## redis
##
docker-compose exec redis redis-cli FLUSHALL

##
## rabbitmq
##
docker-compose exec rabbitmq rabbitmqctl stop_app
# Be sure you really want to do this!
docker-compose exec rabbitmq rabbitmqctl reset
docker-compose exec rabbitmq rabbitmqctl start_app
