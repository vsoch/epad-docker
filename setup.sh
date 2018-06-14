#!/bin/bash

# Create Dicomproxy Hierarchy
docker-compose up -d mysql
sleep 10
docker exec mysql sh /home/install.sh
sleep 10
docker exec mysql sh /home/install.sh
docker-compose up -d exist
sleep 10
docker-compose up -d dcm4chee epad
sleep 10
docker exec mysql sh /home/install.sh
docker-compose restart dcm4chee
