# Mantl Kibana

[![Build Status](http://drone04.shipped-cisco.com/api/badges/CiscoCloud/mantl-kibana/status.svg)](http://drone04.shipped-cisco.com/CiscoCloud/mantl-kibana)

Kibana Docker image used by the
[ELK addon](http://docs.mantl.io/en/latest/components/elk.html) for
[Mantl](http://mantl.io/) clusters.

This image that utilizes consul-template to discover the host and port of the
specified Elasticsearch service. This image also creates and sets the default
Kibana index pattern and creates a simple Dashboard in Kibana.
