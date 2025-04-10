#!/bin/bash

apt-get update -y --exclude=kernel
apt-get install -y vim netcat telnet