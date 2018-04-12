---
title: Getting started
description: Get up and running with Jaeger in your local environment
weight: 2
---

## Instrumentation

Your applications must be instrumented before they can send tracing data to a Jaeger backend. See the [Client libraries](../client-libraries) page for information about how to use the [OpenTracing API](http://opentracing.io/) and how to initialize and configure Jaeger tracers.

## All-in-one Docker image {#docker}

Jaeger provides an "all-in-one" Docker image, designed for quick local testing, that launches the Jaeger UI, [query](../architecture#agent), and [agent](../architecture#agent), along with an in-memory storage component.

You can start the [`jaegertracing/all-in-one`](https://hub.docker.com/r/jaegertracing/all-in-one/) image using this single command:

```bash
$ docker run -d -e \
  COLLECTOR_ZIPKIN_HTTP_PORT=9411 \
  -p 5775:5775/udp \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 14268:14268 \
  -p 9411:9411 \
  jaegertracing/all-in-one:latest
```

You can then navigate to `http://localhost:16686` to access the Jaeger UI.

The container exposes the following ports:

Port | Protocol | Component | Function
---- | -------  | --------- | ---
5775 | UDP      | agent     | Accepts `zipkin.thrift` over the [Thrift compact protocol](https://github.com/apache/thrift/blob/master/doc/specs/thrift-compact-protocol.md)
6831 | UDP      | agent     | Accepts `zipkin.thrift` over the [Thrift compact protocol](https://github.com/apache/thrift/blob/master/doc/specs/thrift-compact-protocol.md)
6832 | UDP      | agent     | Accepts `jaeger.thrift` over the [Thrift binary protocol](https://github.com/apache/thrift/blob/master/doc/specs/thrift-binary-protocol.md)
5778 | HTTP     | agent     | Serves configs
16686| HTTP     | query     | Serves the Jaeger frontend
14268 | HTTP     | collector | Accepts `jaeger.thrift` directly from clients
9411 | HTTP     | collector | Zipkin-compatible endpoint

## Kubernetes and OpenShift

[Kubernetes](https://github.com/jaegertracing/jaeger-kubernetes) and [OpenShift](https://github.com/jaegertracing/jaeger-openshift) templates can be found in the [jaegertracing](https://github.com/jaegertracing/) organization on Github.

## Sample Application

### HotROD (Rides on Demand)

HotROD is a demo application that consists of several microservices and illustrates usage of the [OpenTracing API](http://opentracing.io). A tutorial/walkthrough is available in the [Take OpenTracing for a HotROD ride](https://medium.com/@YuriShkuro/take-opentracing-for-a-hotrod-ride-f6e3141f7941) blog post.

It can be run standalone but requires Jaeger backend to view the {{< tip "traces" "trace" >}}.

#### Running the application

```bash
$ mkdir -p $GOPATH/src/github.com/jaegertracing
$ cd $GOPATH/src/github.com/jaegertracing
$ git clone git@github.com:jaegertracing/jaeger.git jaeger
$ cd jaeger
$ make install
$ cd examples/hotrod
$ go run ./main.go all
```

Then navigate to `http://localhost:8080`.


#### Features

-   Discover architecture of the whole system via data-driven dependency
    diagram.
-   View request timeline and errors; understand how the app works.
-   Find sources of latency and lack of concurrency.
-   Highly contextualized logging.
-   Use baggage propagation to:

    -   Diagnose inter-request contention (queueing).
    -   Attribute time spent in a service.

-   Use open source libraries with OpenTracing integration to get
    vendor-neutral instrumentation for free.

#### Prerequisites

-   You need Go 1.9 or higher installed on your machine.
-   Requires a [running Jaeger backend](#docker) to view the {{< tip "traces" "trace" >}}.

## Client Libraries

Look [here](../client-libraries).

## Running Individual Jaeger Components

Individual Jaeger backend components can be run from source.
They all have their `main.go` in the `cmd` folder. For example, to run the `jaeger-agent`:

```bash
$ mkdir -p $GOPATH/src/github.com/jaegertracing
$ cd $GOPATH/src/github.com/jaegertracing
$ git clone git@github.com:jaegertracing/jaeger.git jaeger
$ cd jaeger
$ make install
$ go run ./cmd/agent/main.go
```

## Migrating from Zipkin

Collector service exposes Zipkin compatible REST API `/api/v1/spans` and `/api/v2/spans` for both
JSON and thrift encoding.
By default it's disabled. It can be enabled with `--collector.zipkin.http-port=9411`.

Zipkin Thrift IDL file can be found in [jaegertracing/jaeger-idl](https://github.com/jaegertracing/jaeger-idl/blob/master/thrift/zipkincore.thrift).
It's compatible with [openzipkin/zipkin-api](https://github.com/openzipkin/zipkin-api/blob/master/thrift/zipkinCore.thrift)
