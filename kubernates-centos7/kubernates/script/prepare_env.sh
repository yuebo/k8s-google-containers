#!/bin/bash
systemctl stop firewalld
systemctl disable firewalld
swapoff -a

ehco "vi /etc/sysconfig/selinux, and set the SELINUX=disabled"
