---
title: Features
weight: 3
---

Jaeger is used for monitoring and troubleshooting microservices-based distributed systems, including:

* Distributed context propagation
* Distributed transaction monitoring
* Root cause analysis
* Service dependency analysis
* Performance / latency optimization

## High Scalability

Jaeger backend is designed to have no single points of failure and to scale with your business needs. Any given Jaeger installation at Uber, for example, typically processes several billion {{< tip "spans" "span" >}} per day.

## Native support for OpenTracing

Jaeger's backend, web UI, and instrumentation libraries have been designed from the ground up to support the [OpenTracing](http://opentracing.io/) standard.

* Represents {{< tip "traces" "trace" >}} as {{< tip "directed acyclic graphs" "directed acyclic graph" >}} (not just trees) via [span references](https://github.com/opentracing/specification/blob/master/specification.md#references-between-spans)
* Supports strongly typed span _tags_ and _structured logs_
* Supports general distributed context propagation mechanism via {{< tip "baggage" >}}

## Multiple storage backends

Jaeger supports two popular open source NoSQL databases as trace storage backends: [Cassandra](http://cassandra.apache.org/) 3.4+ and [Elasticsearch](https://www.elastic.co/) 5.x/6.x. There are ongoing community experiments using other databases, such as [ScyllaDB](https://www.scylladb.com/), [InfluxDB](https://www.influxdata.com/), and [Amazon DynamoDB](https://aws.amazon.com/dynamodb/). Jaeger also ships with a simple in-memory storage for testing setups.

## Modern Web UI

The Jaeger Web UI is implemented in JavaScript using popular open source frameworks like [React](https://reactjs.org/). Several performance improvements have been released in v1.0 to allow the UI to efficiently deal with large volumes of data and to display {{< tip "traces" "trace" >}} with tens of thousands of {{< tip "spans" "span" >}} (e.g. we tried a trace with 80,000 spans).

## Cloud Native Deployment

Jaeger backend is distributed as a collection of Docker images. The binaries support various configuration methods, including command-line options, environment variables, and configuration files in multiple formats (YAML, TOML, etc.) Deployment to Kubernetes clusters is assisted by [Kubernetes templates](https://github.com/jaegertracing/jaeger-kubernetes) and a [Helm chart](https://github.com/kubernetes/charts/tree/master/incubator/jaeger).

## Observability

All Jaeger backend components expose [Prometheus](https://prometheus.io/) metrics by default (other metrics backends are also supported). Logs are written to stdout using the structured logging library [zap](https://github.com/uber-go/zap).

## Backwards compatibility with Zipkin

Although we recommend instrumenting applications with the OpenTracing API and binding to Jaeger client libraries to benefit from advanced features not available elsewhere, you don't have to rewrite your code if your organization has already invested in the instrumentation using Zipkin libraries. Jaeger provides backwards compatibility with Zipkin by accepting spans in Zipkin formats (Thrift or JSON v1/v2) over HTTP. Switching from a Zipkin backend is just a matter of routing the traffic from Zipkin libraries to the Jaeger backend.
