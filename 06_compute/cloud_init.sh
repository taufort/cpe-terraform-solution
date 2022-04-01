#!/usr/bin/env bash

set -x

yum install -y httpd
systemctl start httpd
