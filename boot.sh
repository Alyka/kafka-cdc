#!/bin/sh

# Delete connector
echo "Deleting existing connector..."
curl -X DELETE localhost:8083/connectors/vas-connector

# Pause for a moment to ensure the delete completes
sleep 2

# Configure connector
echo "Configuring new connector..."
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d @postgresql-connect.json

echo "Connector configured."