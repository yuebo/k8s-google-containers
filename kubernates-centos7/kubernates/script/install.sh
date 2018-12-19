#!/usr/bin/env bash
sh prepare_env.sh
sh install_docker.sh
sh install_kubeadm.sh
sh export_cert.sh
sh get_token.sh