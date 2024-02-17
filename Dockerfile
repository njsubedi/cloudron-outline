FROM cloudron/base:4.0.0@sha256:31b195ed0662bdb06a6e8a5ddbedb6f191ce92e8bee04c03fb02dd4e9d0286df

ARG VERSION=0.75.0

EXPOSE 3000

RUN mkdir -p /app/code /app/data

WORKDIR /app/code

RUN curl -L https://github.com/outline/outline/archive/refs/tags/v${VERSION}.tar.gz | tar zx --strip-components 1 -C /app/code && \
    yarn --pure-lockfile && \
    yarn build && \
    yarn --production --ignore-scripts --prefer-offline  --ignore-platform && \
    rm -rf shared && \
    rm -rf /home/cloudron/.yarn && ln -s /run/.yarn /home/cloudron/.yarn && \
    rm -rf /home/cloudron/.cache && ln -s /run/.cache /home/cloudron/.cache && \
    ln -sf /app/data/env /app/code/.env

COPY start.sh /app/code

ENV NODE_ENV production

CMD [ "/app/code/start.sh"]
