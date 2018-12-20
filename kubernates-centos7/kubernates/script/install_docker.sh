#!/usr/bin/env bash
curl -sSL https://get.daocloud.io/docker | sh
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://e7850958.m.daocloud.io
systemctl enable docker
systemctl restart docker
