#!/bin/bash

set -eo pipefail

cd NativeMarkKit; swift test --parallel; cd ..
