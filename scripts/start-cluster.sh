#!/bin/bash
echo "Waiting CockroachDB to launch on 26257..."
while ! nc -z $1 26257; do
  sleep 0.1
done
echo "CockroachDB is launched!"
cockroach init --insecure --host=$1