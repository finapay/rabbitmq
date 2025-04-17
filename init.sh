#!/bin/bash

# Configuration
RABBITMQ_USER=guest
RABBITMQ_PASS=guest
RABBITMQ_HOST=rabbitmq
RABBITMQ_API_PORT=15672
EXCHANGE_NAME=delayed_exchange
EXCHANGE_TYPE=x-delayed-message
VHOST=/
DELAYED_TYPE=direct

# Attendre que RabbitMQ soit prêt
echo "⏳ Attente de RabbitMQ..."
until curl -u "$RABBITMQ_USER:$RABBITMQ_PASS" -s -f "http://$RABBITMQ_HOST:$RABBITMQ_API_PORT/api/overview" > /dev/null; do
    sleep 3
done

echo "✅ RabbitMQ est prêt. Création de l'exchange $EXCHANGE_NAME..."

# Créer l'exchange via l'API HTTP
curl -u "$RABBITMQ_USER:$RABBITMQ_PASS" -X PUT \
  -H "Content-Type: application/json" \
  -d '{
        "type":"'"$EXCHANGE_TYPE"'",
        "durable":true,
        "auto_delete":false,
        "internal":false,
        "arguments":{
          "x-delayed-type":"'"$DELAYED_TYPE"'"
        }
      }' \
  "http://$RABBITMQ_HOST:$RABBITMQ_API_PORT/api/exchanges/$(echo -n "$VHOST" | jq -sRr @uri)/$EXCHANGE_NAME"

echo "✅ Exchange $EXCHANGE_NAME créé avec succès !"
