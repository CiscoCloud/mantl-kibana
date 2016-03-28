#!/bin/bash
set -e

# Required vars
export ELASTICSEARCH_SERVICE=${ELASTICSEARCH_SERVICE:-client_port.elasticsearch-executor}
export KIBANA_SERVICE=${KIBANA_SERVICE:-kibana}
export KIBANA_IMAGE_TAG=${KIBANA_IMAGE_TAG:-4.3.2}
export KIBANA_BUILD_NUM=${KIBANA_BUILD_NUM:-9520}

CONSUL_TEMPLATE=${CONSUL_TEMPLATE:-/usr/local/bin/consul-template}
CONSUL_CONFIG=${CONSUL_CONFIG:-/consul-template/config.d}
CONSUL_CONNECT=${CONSUL_CONNECT:-consul.service.consul:8500}
CONSUL_MINWAIT=${CONSUL_MINWAIT:-2s}
CONSUL_MAXWAIT=${CONSUL_MAXWAIT:-10s}
CONSUL_LOGLEVEL=${CONSUL_LOGLEVEL:-warn}
CONSUL_SSL_VERIFY=${CONSUL_SSL_VERIFY:-true}

[[ -n "${CONSUL_CONNECT}" ]] && ctargs="${ctargs} -consul ${CONSUL_CONNECT}"
[[ -n "${CONSUL_SSL}" ]] && ctargs="${ctargs} -ssl"
[[ -n "${CONSUL_SSL}" ]] && ctargs="${ctargs} -ssl-verify=${CONSUL_SSL_VERIFY}"
[[ -n "${CONSUL_TOKEN}" ]] && ctargs="${ctargs} -token ${CONSUL_TOKEN}"

vars=$@

${CONSUL_TEMPLATE} -config ${CONSUL_CONFIG} \
                   -log-level ${CONSUL_LOGLEVEL} \
                   -wait ${CONSUL_MINWAIT}:${CONSUL_MAXWAIT} \
                   ${ctargs} ${vars}
