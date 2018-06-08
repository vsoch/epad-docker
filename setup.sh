#!/bin/bash

# Create Dicomproxy Hierarchy
docker-compose up -d mysql
sleep 10
docker exec mysql sh /home/install.sh
docker-compose up -d dcm4chee exist epad
