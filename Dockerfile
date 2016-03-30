FROM kibana:4.3.2
MAINTAINER Ryan Eschinger <ryanesc@gmail.com>
ENV CONSUL_TEMPLATE_VERSION=0.14.0

# optimize bundle assets in advance for running under /kibana
# see https://github.com/elastic/kibana/issues/6057
RUN echo "\nserver.basePath: /kibana" >> /opt/kibana/config/kibana.yml
RUN timeout 120 /opt/kibana/node/bin/node /opt/kibana/src/cli/ || true

RUN apt-get update && apt-get install -y \
    unzip curl jq \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /

RUN unzip /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip  && \
    mv /consul-template /usr/local/bin/consul-template && \
    rm -rf /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

RUN mkdir -p /consul-template/config.d /consul-template/template.d

ADD config/ /consul-template/config.d/
ADD template/ /consul-template/template.d/
ADD launch.sh /launch.sh

ENTRYPOINT ["tini", "--", "/launch.sh"]
