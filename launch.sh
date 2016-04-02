#!/bin/bash
set -ex

# Required vars
export ELASTICSEARCH_SERVICE=${ELASTICSEARCH_SERVICE:-client_port.elasticsearch-executor}
export KIBANA_SERVICE=${KIBANA_SERVICE:-kibana}
export KIBANA_IMAGE_TAG=${KIBANA_IMAGE_TAG:-4.3.2}
export KIBANA_BUILD_NUM=${KIBANA_BUILD_NUM:-9520}

CONSUL_TEMPLATE=${CONSUL_TEMPLATE:-/usr/local/bin/consul-template}
CONSUL_CONNECT=${CONSUL_CONNECT:-consul.service.consul:8500}
CONSUL_MINWAIT=${CONSUL_MINWAIT:-2s}
CONSUL_MAXWAIT=${CONSUL_MAXWAIT:-10s}
CONSUL_LOGLEVEL=${CONSUL_LOGLEVEL:-warn}
CONSUL_SSL_VERIFY=${CONSUL_SSL_VERIFY:-true}

[[ -n "${CONSUL_CONNECT}" ]] && ctargs="${ctargs} -consul ${CONSUL_CONNECT}"
[[ -n "${CONSUL_SSL}" ]] && ctargs="${ctargs} -ssl"
[[ -n "${CONSUL_SSL}" ]] && ctargs="${ctargs} -ssl-verify=${CONSUL_SSL_VERIFY}"
[[ -n "${CONSUL_TOKEN}" ]] && ctargs="${ctargs} -token ${CONSUL_TOKEN}"

wait_for_config() {
    ${CONSUL_TEMPLATE} -config /consul-template/config.d/kibana.cfg \
                       -log-level ${CONSUL_LOGLEVEL} \
                       -wait ${CONSUL_MINWAIT}:${CONSUL_MAXWAIT} \
                       -once \
                       ${ctargs}

    # make sure we found an elasticsearch service to connect to
    grep elasticsearch.url \
         /opt/kibana/config/kibana.yml 1>/dev/null
}

vars=$@

# wait until we discover a valid elasticsearch service to connect to
ATTEMPT=0
until wait_for_config || [ $ATTEMPT -eq 6 ]; do
    echo "waiting for Kibana configuration..."
    cat /opt/kibana/config/kibana.yml
    echo "attempt: $(( ATTEMPT++ ))"
    sleep 10
done

if [[ $ATTEMPT -eq 6 ]]; then
    echo "$ELASTICSEARCH_SERVICE not found."
    exit 1
fi

# show config
cat /opt/kibana/config/kibana.yml

# run consul-template in the background to create index pattern + dashboard
${CONSUL_TEMPLATE} -config /consul-template/config.d/kibana-dashboard.cfg \
                   -log-level ${CONSUL_LOGLEVEL} \
                   -wait ${CONSUL_MINWAIT}:${CONSUL_MAXWAIT} \
                   ${ctargs} &

# run kibana
exec kibana ${vars}
