# Mantl Kibana

[![Build Status](https://travis-ci.org/CiscoCloud/mantl-kibana.svg?branch=master)](https://travis-ci.org/CiscoCloud/mantl-kibana)

Kibana Docker image used by the
[ELK addon](http://docs.mantl.io/en/latest/components/elk.html) for
[Mantl](http://mantl.io/) clusters.

This image that utilizes consul-template to discover the host and port of the
specified Elasticsearch service. This image also creates and sets the default
Kibana index pattern and creates a simple Dashboard in Kibana.
