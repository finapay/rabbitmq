FROM rabbitmq:3.12-management

# Installe curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Variables
ENV RABBITMQ_DELAYED_MSG_PLUGIN_VERSION=3.12.0

# Téléchargement du plugin (compatible avec RabbitMQ 3.12)
# https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v3.12.0/rabbitmq_delayed_message_exchange-3.12.0.ez
RUN curl -L -o /opt/rabbitmq/plugins/rabbitmq_delayed_message_exchange-${RABBITMQ_DELAYED_MSG_PLUGIN_VERSION}.ez \
  https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v${RABBITMQ_DELAYED_MSG_PLUGIN_VERSION}/rabbitmq_delayed_message_exchange-${RABBITMQ_DELAYED_MSG_PLUGIN_VERSION}.ez

# Assure que les droits sont bons
RUN chmod 644 /opt/rabbitmq/plugins/rabbitmq_delayed_message_exchange-${RABBITMQ_DELAYED_MSG_PLUGIN_VERSION}.ez

# Active le plugin en mode offline
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
