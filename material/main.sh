#!/bin/bash

# initializing kubeadm :
sudo kubeadm init

# copying config file :
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# adding calico networking solution :
kubectl apply -f https://docs.projectcalico.org/v3.20/manifests/calico.yaml

# generating kubejoin.sh :
kubeadm token create --print-join-command

# now copy the output of the last command, and execute it on the worker node.