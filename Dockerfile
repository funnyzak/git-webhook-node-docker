FROM funnyzak/alpine-glibc

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vendor="potato<silenceace@gmail.com>" \
    org.label-schema.name="GitWebhookNode" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.description="Pull your nodejs project git code into a data volume and trigger node event via Webhook." \
    org.label-schema.url="https://yycc.me" \
    org.label-schema.schema-version="1.0"	\
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-ref="${VCS_REF}" \
    org.label-schema.vcs-url="https://github.com/funnyzak/git-webhook-node-docker" 

ENV LANG=C.UTF-8

# Install needed modules
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh go rsync npm nodejs tzdata && \
    rm  -rf /tmp/* /var/cache/apk/*

# Go config
RUN mkdir -p /go/src /go/bin && chmod -R 777 /go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

# Install webhook
RUN go get github.com/adnanh/webhook

# Create Dir
RUN mkdir -p /app/hook && mkdir -p /app/code

# Copy webhook config
COPY conf/hooks.json /app/hook/hooks.json
COPY scripts/hook.sh /app/hook/hook.sh

# Copy our Scripts
COPY scripts/start.sh /usr/bin/start.sh
COPY scripts/run_scripts_after_pull.sh /usr/bin/run_scripts_after_pull.sh
COPY scripts/run_scripts_before_pull.sh /usr/bin/run_scripts_before_pull.sh
COPY scripts/run_scripts_on_startup.sh /usr/bin/run_scripts_on_startup.sh

# Add permissions to our scripts
RUN chmod +x /app/hook/hook.sh
RUN chmod +x /usr/bin/run_scripts_after_pull.sh
RUN chmod +x /usr/bin/run_scripts_before_pull.sh
RUN chmod +x /usr/bin/run_scripts_on_startup.sh

# Add any user custom scripts + set permissions
ADD custom_scripts /custom_scripts
RUN chmod +x -R /custom_scripts

RUN chmod +x -R /app/code
WORKDIR /app/code

# Expose Webhook port
EXPOSE 9000

# run start script
ENTRYPOINT ["sh", "/usr/bin/start.sh"]
