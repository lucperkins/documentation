---
title: Cassandra
versions: true
---

Deploying Cassandra itself is out of scope for our documentation. One good source of documentation is the [Apache Cassandra docs](https://cassandra.apache.org/doc/latest/).

#### Schema script

A script is provided to initialize the Cassandra keyspace and schema using Cassandra's interactive shell, [`cqlsh`](http://cassandra.apache.org/doc/latest/tools/cqlsh.html):

```sh
MODE=test sh ./plugin/storage/cassandra/schema/create.sh | cqlsh
```

For production deployment, pass `MODE=prod DATACENTER={datacenter}` arguments to the script,
where `{datacenter}` is the name used in the Cassandra configuration/network topology.

The script also allows overriding TTL, keyspace name, replication factor, etc.
Run the script without arguments to see the full list of recognized parameters.

#### TLS support

Jaeger supports TLS client-to-node connections provided that you've configured your Cassandra cluster correctly. After verifying this, for example with `cqlsh`, you can configure the {{< tip "collector" >}} and {{< tip "query" >}} like so:

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

The schema tool also supports TLS. To use TLS, you'll need to make a custom `cqlshrc` file that looks something like this:

```ini
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