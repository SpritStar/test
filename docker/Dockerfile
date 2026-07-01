FROM nginx:latest

ARG LLM=ChatGPT
LABEL LLM=${FUNCTION}

LABEL FUNCTION=TEST
COPY . /usr/share/nginx/html
EXPOSE 80

