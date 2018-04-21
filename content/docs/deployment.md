---
title: Deployment
weight: 6
menu: docs
---

The main Jaeger backend components are released as Docker images on [Docker Hub](https://hub.docker.com/r/jaegertracing):

Component             | Repository
--------------------- | ---
**jaeger-agent**      | [hub.docker.com/r/jaegertracing/jaeger-agent/](https://hub.docker.com/r/jaegertracing/jaeger-agent/)
**jaeger-collector**  | [hub.docker.com/r/jaegertracing/jaeger-collector/](https://hub.docker.com/r/jaegertracing/jaeger-collector/)
**jaeger-query**      | [hub.docker.com/r/jaegertracing/jaeger-query/](https://hub.docker.com/r/jaegertracing/jaeger-query/)

There are orchestration templates for running Jaeger with:

* [Kubernetes](https://github.com/jaegertracing/jaeger-kubernetes)
* [OpenShift](https://github.com/jaegertracing/jaeger-openshift)

## Agent

Jaeger client libraries expect the **jaeger-agent** process to be running locally on each host. The Jaeger {{< tip "agent" >}}  exposes the following ports:

Port | Protocol | Function
:----|:---------|:--------
5775 | UDP      | Accepts `zipkin.thrift` over the compact Thrift protocol
6831 | UDP      | Accepts `jaeger.thrift` over the compact thrift protocol
6832 | UDP      | Accepts `jaeger.thrift` over the binary Thrift protocol
5778 | HTTP     | Serves configs and sampling strategies

The {{< tip "agent" >}} can be executed directly on the host or via Docker, as follows:

```bash
## make sure to expose only the ports you use in your deployment scenario!
$ docker run \
  --rm \
  -p5775:5775/udp \
  -p6831:6831/udp \
  -p6832:6832/udp \
  -p5778:5778/tcp \
  jaegertracing/jaeger-agent
```

### Discovery System Integration

The agents can connect point to point to a single {{< tip "collector" >}} address, which can be load balanced by another infrastructure component (e.g. DNS) across multiple collectors. The agent can also be configured with a static list of collector addresses.

In Docker, a command like the following can be used:

```bash
$ docker run \
  --rm \
  -p5775:5775/udp \
  -p6831:6831/udp \
  -p6832:6832/udp \
  -p5778:5778/tcp \
  jaegertracing/jaeger-agent \
  /go/bin/agent-linux --collector.host-port=jaeger-collector.jaeger-infra.svc:14267
```

In the future, we'll support different service discovery systems to dynamically load balance across several collectors (see [issue 213](https://github.com/jaegertracing/jaeger/issues/213)).

## Collectors

Jaeger {{< tip "collectors" "collector" >}} are stateless and thus many instances of **jaeger-collector** can be run in parallel. Collectors require almost no configuration, except for the location of the Cassandra cluster via the `--cassandra.keyspace` and `--cassandra.servers` options, or the location of the Elasticsearch cluster via `--es.server-urls`, depending on which storage is specified. To see all command-line options, run:

```bash
$ go run ./cmd/collector/main.go -h
```

Or, if you don't have the source code:

```bash
$ docker run -it --rm jaegertracing/jaeger-collector /go/bin/collector-linux -h
```

When using the default settings, the collector exposes the following ports:

Port  | Protocol | Function
:-----|:---------|:--------
14267 | TChannel | Used by **jaeger-agent** to send spans in `jaeger.thrift` format
14268 | HTTP     | Can accept spans directly from clients in `jaeger.thrift` format
9411  | HTTP     | Can accept Zipkin spans in JSON or Thrift (disabled by default)


## Storage Backend

Collectors require a persistent storage backend. Cassandra and ElasticSearch are the primary supported storage backends. Additional backends are [discussed here](https://github.com/jaegertracing/jaeger/issues/638).

The storage type can be passed via the `SPAN_STORAGE_TYPE` environment variable. Valid values are `cassandra`, `elasticsearch`, and `memory` (the memory backend can only be used if you're running an all-in-one binary).

### Cassandra

Supported versions: **{{< version "cassandra" >}}**

Deploying Cassandra itself is out of scope for our documentation. One good
source of documentation is the [Apache Cassandra Docs](https://cassandra.apache.org/doc/latest/).

#### Schema script

A script is provided to initialize Cassandra keyspace and schema
using Cassandra's interactive shell [`cqlsh`][cqlsh]:

```sh
MODE=test sh ./plugin/storage/cassandra/schema/create.sh | cqlsh
```

For production deployment, pass `MODE=prod DATACENTER={datacenter}` arguments to the script,
where `{datacenter}` is the name used in the Cassandra configuration / network topology.

The script also allows overriding TTL, keyspace name, replication factor, etc.
Run the script without arguments to see the full list of recognized parameters.

#### TLS support

Jaeger supports TLS client to node connections as long as you've configured
your Cassandra cluster correctly. After verifying with e.g. `cqlsh`, you can
configure the collector and query like so:

```bash
$ docker run \
  -e CASSANDRA_SERVERS=<...> \
  -e CASSAMDRA_TLS=true \
  -e CASSANDRA_TLS_SERVER_NAME="CN-in-certificate" \
  -e CASSANDRA_TLS_KEY=<path to client key file> \
  -e CASSANDRA_TLS_CERT=<path to client cert file> \
  -e CASSANDRA_TLS_CA=<path to your CA cert file> \
  jaegertracing/jaeger-collector
```

The schema tool also supports TLS. You need to make a custom cqlshrc file like
so:

```conf
# Creating schema in a cassandra cluster requiring client TLS certificates.
#
# Create a volume for the schema docker container containing four files:
# cqlshrc: this file
# ca-cert: the cert authority for your keys
# client-key: the keyfile for your client
# client-cert: the cert file matching client-key
#
# if there is any sort of DNS mismatch and you want to ignore server validation
# issues, then uncomment validate = false below.
#
# When running the container, map this volume to /root/.cassandra and set the
# environment variable CQLSH_SSL=--ssl
[ssl]
certfile = ~/.cassandra/ca-cert
userkey = ~/.cassandra/client-key
usercert = ~/.cassandra/client-cert
# validate = false
```

### ElasticSearch

Supported versions: **{{< version "elasticsearch" >}}**

ElasticSearch does not require initialization other than
[installing and running ElasticSearch](https://www.elastic.co/downloads/elasticsearch).
Once it is running, pass the correct configuration values to the Jaeger collector and query service.

#### Shards and Replicas for ElasticSearch indices

Shards and replicas are some configuration values to take special attention to, because this is decided upon
index creation. [This article](https://qbox.io/blog/optimizing-elasticsearch-how-many-shards-per-index) goes into
more information about choosing how many shards should be chosen for optimization.

## Query Service & UI

**jaeger-query** serves the API endpoints and a React/Javascript UI.
The service is stateless and is typically run behind a load balancer, e.g. nginx.

At default settings the query service exposes the following port(s):

Port  | Protocol | Function
----- | -------  | ---
16686 | HTTP     | **/api/*** endpoints and Jaeger UI at **/**

### UI Base Path

The base path for all **jaeger-query** HTTP routes can be set to a non-root value, e.g. `/jaeger` would cause all UI URLs to start with `/jaeger`. This can be useful when running **jaeger-query** behind a reverse proxy.

The base path can be configured via the `--query.base-path` command line parameter or the `QUERY_BASE_PATH` environment variable.

### UI Configuration

Several aspects of the UI can be configured:

* The Dependencies section can be enabled/configured
* Google Analytics tracking can be enabled/configured
* Additional menu options can be added to the global nav

These options can be configured by a JSON configuration file. The `--query.ui-config` command line parameter of the query service must then be set to the path to the JSON file when the query service is started.

Here's an example configuration file:

```json
{
  "dependencies": {
    "dagMaxNumServices": 200,
    "menuEnabled": true
  },
  "tracking": {
    "gaID": "UA-000000-2",
    "trackErrors": true
  },
  "menu": [
    {
      "label": "About Jaeger",
      "items": [
        {
          "label": "GitHub",
          "url": "https://github.com/jaegertracing/jaeger"
        },
        {
          "label": "Docs",
          "url": "http://jaeger.readthedocs.io/en/latest/"
        }
      ]
    }
  ]
}
```

Parameter | Description | Default
:---------|:------------|:-------
`dependencies.dagMaxNumServices` | Defines the maximum number of services allowed before the DAG dependency view is disabled | `200`
`dependencies.menuEnabled` | Enables (`true`) or disables (`false`) the dependencies menu button | `true`
`tracking.gaID` | Defines the Google Analytics tracking ID. This is required for Google Analytics tracking, and setting it to a non-`null` value enables Google Analytics tracking. | `null`
`tracking.trackErrors` | Enables (`true`) or disables (`false`) error tracking via Google Analytics. Errors can only be tracked if a valid Google Analytics ID is provided. For additional details on error tracking via Google Analytics see the [tracking README](https://github.com/jaegertracing/jaeger-ui/blob/c622330546afc1be59a42f874bcc1c2fadf7e69a/src/utils/tracking/README.md) in the UI repo. | `true`
`menu` | Allows additional links to be added to the global nav. The additional links are right-aligned. |

In the sample JSON config above, the configured menu will have a dropdown labeled "About Jaeger" with sub-options for "GitHub" and "Docs." The format for a link in the top right menu is as follows:

```json
{
  "label": "Some text here",
  "url": "https://example.com"
}
```

Links can either be members of the `menu` Array, directly, or they can be grouped into a dropdown menu option. The format for a group of links is:

```json
{
  "label": "Dropdown button",
  "items": []
}
```

The `items` Array should contain one or more link configurations.

TODO: Swagger and GraphQL API ([issue 158](https://github.com/jaegertracing/jaeger/issues/158)).

## Aggregation Jobs for Service Dependencies

Production deployments need an external process which aggregates data and creates dependency links between services. Project [spark-dependencies](https://github.com/jaegertracing/spark-dependencies) is a Spark job which derives dependency links and stores them directly to the storage.

## Configuration

All binaries accepts command-line properties and environment variables which are managed by by [viper](https://github.com/spf13/viper) and [cobra](https://github.com/spf13/cobra). The names of environmental properties are capital letters and characters `-` and `.` are replaced with `_`. To list all configuration properties, run `jaeger-binary -h`.

[cqlsh]: http://cassandra.apache.org/doc/latest/tools/cqlsh.html
