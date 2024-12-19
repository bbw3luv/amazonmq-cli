FROM openjdk:11-jre-slim

ENV AMAZONMQ_TCP=61617 AMAZONMQ_AMQP=8162
RUN useradd -ms /bin/bash amazonmq

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    bash \
    && rm -rf /var/lib/apt/lists/*

ARG AMAZONMQ_CLI_VERSION=0.2.2

RUN curl -L https://github.com/antonwierenga/amazonmq-cli/releases/download/v${AMAZONMQ_CLI_VERSION}/amazonmq-cli-${AMAZONMQ_CLI_VERSION}.zip -o /tmp/amazonmq-cli.zip && \
    unzip /tmp/amazonmq-cli.zip -d /tmp && \
    mv /tmp/amazonmq-cli-${AMAZONMQ_CLI_VERSION} /usr/local/bin/amazonmq-cli && \
    rm /tmp/amazonmq-cli.zip

RUN chmod -R 755 /usr/local/bin/amazonmq-cli

# Switch to the amazonmq user
USER amazonmq
WORKDIR /home/amazonmq

RUN  echo "export PATH=/usr/local/openjdk-11/bin:\$PATH:/usr/local/bin/amazonmq-cli/bin" >> /home/amazonmq/.bashrc
RUN  echo "export JAVA_HOME=/usr/local/openjdk-11" >> /home/amazonmq/.bashrc

# Set the entry point
ENTRYPOINT ["/usr/local/bin/amazonmq-cli/bin/amazonmq-cli"]
