#!/bin/sh

docker build -t test_shawkopt .
docker run --rm  test_shawkopt ./test.sh
