#!/bin/bash

echo "=======> disabeling swap :"
swapoff -a

echo "=======> configuring prerequisites for using containerd at the CRI :"
cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter
# Setup required sysctl params, these persist across reboots.
cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
# Apply sysctl params without reboot
sysctl --system

echo "=======> installing required packages :"
apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common apt-utils

echo "=======> installing containerd.io :"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt-get update && apt-get install -y containerd.io

echo "=======> configuring containerd :"
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml

echo "=======> restarting containerd :"
systemctl restart containerd

echo "=======> checking containerd status :"
systemctl is-active containerd

echo "=======> adding kubernetes repo :"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
echo "=======> updating repos :"
apt-get update && apt-get install -y kubeadm kubelet kubectl

