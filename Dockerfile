FROM alpine:3.15
MAINTAINER Cagatay Gurturk <cguertuerk@ebay.de>

RUN apk add --update openssh-client autossh && rm -rf /var/cache/apk/*

CMD rm -rf /root/.ssh && mkdir /root/.ssh && cp -R /root/ssh/* /root/.ssh/ && chmod -R 600 /root/.ssh/* && \
if [ "$FORWARD_DIRECTION" = "remote" ]; then FORWARD_OPTION="-R"; else FORWARD_OPTION="-L"; fi && \
if [ "$USE_AUTOSSH" = "yes" ]; \
    then \
        SSH_COMMAND="autossh"; \
        AUTOSSH_OPTIONS="-M 0"; \
    else \
        SSH_COMMAND="ssh"; \
        AUTOSSH_OPTIONS=""; \
fi && \
$SSH_COMMAND \
$AUTOSSH_OPTIONS \
$SSH_DEBUG \
-o StrictHostKeyChecking=no \
-o ExitOnForwardFailure=yes \
-t -t \
$TUNNEL_HOST \
$FORWARD_OPTION *:$LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT
EXPOSE 1-65535
