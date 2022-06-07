FROM cloudron/base:3.2.0@sha256:ba1d566164a67c266782545ea9809dc611c4152e27686fd14060332dd88263ea

ARG VERSION=0.64.3

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
