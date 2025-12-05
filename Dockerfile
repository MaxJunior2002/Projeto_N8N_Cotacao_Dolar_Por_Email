FROM n8nio/n8n:latest

USER root

RUN mkdir -p /home/node/.n8n/workflows && \
    chown -R node:node /home/node/.n8n

COPY workflows /home/node/.n8n/workflows

RUN chown -R node:node /home/node/.n8n/workflows

USER node