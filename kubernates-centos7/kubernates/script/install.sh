#!/usr/bin/env bash
./prepare_env.sh
./install_docker.sh
./install_kubeadm.sh
./export_cert.sh
./get_token.sh