---
title: Architecture
rank: 5
---

Jaeger clients adhere to the data model described in the OpenTracing standard. Reading the [specification](https://github.com/opentracing/specification/blob/master/specification.md) will help you understand this document better.

## Terminology

### Span

A **span** represents a logical unit of work in the system that consists of:

* an operation name
* the start time of the operation
* the duration of the operation

Spans may be nested and ordered to model causal relationships. A [remote procedure call](https://en.wikipedia.org/wiki/Remote_procedure_call) (RPC) is an example of a span.

{{< figure src="/img/spans-traces.png" link="/img/spans-traces.png" caption="An example trace and the spans that comprise it" >}}

### Trace

A **trace** is a data/execution path through the system, and can be thought of as a [directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) (DAG) of [spans](#span).

## Components

{{< figure src="/img/architecture.png" link="/img/architecture.png" caption="The basic architecture of a Jaeger installation" >}}

This section details the core components of Jaeger and how they relate to one other. It's arranged by the order in which spans from your application interact with them.

### Jaeger client libraries

Jaeger clients are language-specific implementations of the [OpenTracing API](http://opentracing.io). They can be used to instrument applications for distributed tracing either manually or with a variety of existing open source frameworks, such as Flask, Dropwizard, gRPC, and many more, that are already integrated with OpenTracing.

An instrumented service creates spans when receiving new requests and attaches context information (trace id, span id, and baggage) to outgoing requests. Only ids and baggage are propagated with requests; all other information that compose a span like operation name, logs, etc. is not propagated. Instead sampled spans are transmitted out of process asynchronously, in the background, to Jaeger Agents.

The instrumentation has very little overhead, and is designed to be always enabled in production.

Note that while all traces are generated, only few are sampled. Sampling a trace marks the trace for further processing and storage.
By default, Jaeger client samples 0.1% of traces (1 in 1000), and has the ability to retrieve sampling strategies from the agent.

{{< figure src="/img/context-prop.png" link="/img/context-prop.png" caption="Context propagation" alt="Jaeger context propagation" >}}

### Agent

The Jaeger **agent** is a network daemon that listens for spans sent over the [User Datagram Protocol](https://en.wikipedia.org/wiki/User_Datagram_Protocol) (UDP) and then batches and sends those spans to the collector. The agent is designed to be deployed to all hosts as an infrastructure component. The agent abstracts the routing and discovery of the collectors away from the client.

### Collector

The Jaeger **collector** receives traces from Jaeger agents and runs them through a processing pipeline. Currently the Jaeger pipeline validates traces, indexes them, performs any transformations, and finally stores them. Jaeger storage is a pluggable component which currently supports [Cassandra](../deployment#cassandra) and [Elasticsearch](../deployment#elasticsearch).

### Query

The Jaeger **query** service retrieves traces from storage and hosts a UI to display them.
