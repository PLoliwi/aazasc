FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y ca-certificates tzdata wget tar curl

WORKDIR /app
COPY . .
RUN chmod -R 777 /app 

## Teldrive
RUN --mount=type=secret,id=gist_teldrive,mode=0444,required=true \
    latest_version=$(curl -s https://api.github.com/repos/divyam234/teldrive/releases/latest | grep "tag_name" | cut -d'"' -f4) && \
    wget https://github.com/divyam234/teldrive/releases/download/$latest_version/teldrive-$latest_version-linux-amd64.tar.gz -O /app/teldrive.tar.gz && \
    tar xvf /app/teldrive.tar.gz -C /app/ && \
    wget $(cat /run/secrets/gist_teldrive) -O /app/config.toml && \
    chmod a+x /app/teldrive && chmod 777 /app/config.toml && \
    touch /app/session.db && \
    chmod 777 /app/session.db

## Start
RUN chmod a+x /app/start.sh

CMD ["./start.sh"]