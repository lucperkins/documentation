---
title: Introduction
rank: 1
---

Welcome to Jaeger's documentation portal! Below, you'll find information for both beginners and experienced Jaeger users.

If you can't find what you are looking for or are curious about an issue not covered here, we'd love to hear from you either on [GitHub](https://github.com/jaegertracing/jaeger/issues), [Gitter chat](https://gitter.im/jaegertracing/Lobby), or our [mailing list](https://groups.google.com/forum/#!forum/jaeger-tracing).

## About

Jaeger, inspired by [Dapper](https://research.google.com/pubs/pub36356.html) and [OpenZipkin](http://zipkin.io), is a distributed tracing system released as open source by [Uber Technologies](https://www.uber.com/info/atg/). It is used for monitoring and troubleshooting microservice-based distributed systems, including:

* Distributed context propagation
* Distributed transaction monitoring
* Root cause analysis
* Service dependency analysis
* Performance/latency optimization

> For more on the history and architectural choices behind Jaeger, see the [Evolving Distributed Tracing at Uber](https://eng.uber.com/distributed-tracing/) post by Jaeger engineer [Yuri Shkuro](https://github.com/yurishkuro) from the [Uber Engineering Blog](https://eng.uber.com/).

## Features

  * [OpenTracing](http://opentracing.io/)-compatible data model and instrumentation libraries for the following langauges/platforms:
    * [Go](https://github.com/jaegertracing/jaeger-client-go)
    * [Java](https://github.com/jaegertracing/jaeger-client-java)
    * [Node.js](https://github.com/jaegertracing/jaeger-client-node)
    * [Python](https://github.com/jaegertracing/jaeger-client-python)
    * [C++](https://github.com/jaegertracing/cpp-client)
  * Uses consistent upfront sampling with individual per-service/endpoint probabilities
  * Multiple supported storage backends:
    * [Cassandra](deployment/#cassandra)
    * [Elasticsearch](deployment/#elasticsearch)
    * Memory.
  * Adaptive sampling (coming soon)
  * Post-collection data processing pipeline (coming soon)

See the [Features](features) page for more details.

## Technical Specs

  * Backend components implemented in [Go 1.9](https://golang.org/doc/go1.9)
  * [React](https://reactjs.org/)-based UI
  * Supported storage backends:
    * [Cassandra 3.4+](deployment/#cassandra)
    * [ElasticSearch 5.x, 6.x](deployment/#elasticsearch)
    * Memory storage

## Quick Start

To get up and running with Jaeger on your machine, see the guide to [running an all-in-one Docker image](getting-started#docker).

## Screenshots

### Traces View
[![Traces View](/img/traces-ss.png)](/img/traces-ss.png)

### Trace Detail View
[![Detail View](/img/trace-detail-ss.png)](/img/trace-detail-ss.png)

## Related links
- [Evolving Distributed tracing At Uber Engineering](https://eng.uber.com/distributed-tracing/)
- [Tracing HTTP request latency in Go with OpenTracing](https://medium.com/opentracing/tracing-http-request-latency-in-go-with-opentracing-7cc1282a100a)
- [Distributed Tracing with Jaeger & Prometheus on Kubernetes](https://blog.openshift.com/openshift-commons-briefing-82-distributed-tracing-with-jaeger-prometheus-on-kubernetes/)
- [Using Jaeger with Istio](https://istio.io/docs/tasks/telemetry/distributed-tracing.html)
- [Using Jaeger with Envoy](https://www.envoyproxy.io/docs/envoy/latest/start/sandboxes/jaeger_tracing.html)

[dapper]: https://research.google.com/pubs/pub36356.html
[ubeross]: http://uber.github.io

