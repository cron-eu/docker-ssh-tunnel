FROM alpine:3.15
MAINTAINER Cagatay Gurturk <cguertuerk@ebay.de>

RUN apk add --update openssh-client && rm -rf /var/cache/apk/*

CMD rm -rf /root/.ssh && mkdir /root/.ssh && cp -R /root/ssh/* /root/.ssh/ && chmod -R 600 /root/.ssh/* && \
if [ "$FORWARD_DIRECTION" = "remote" ]; then FORWARD_OPTION="-R"; else FORWARD_OPTION="-L"; fi && \
ssh \
$SSH_DEBUG \
-o StrictHostKeyChecking=no \
-N $TUNNEL_HOST \
$FORWARD_OPTION *:$LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT \
&& while true; do sleep 30; done;
EXPOSE 1-65535
