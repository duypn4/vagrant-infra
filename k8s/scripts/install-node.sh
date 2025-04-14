#!/bin/bash

export K8S_VERSION=1.32

# install kubeadm
apt-get install -y apt-transport-https ca-certificates curl gpg wget
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$K8S_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$K8S_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# setup container runtime
apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml
containerd config default | sed '/sandbox_image/s|=.*|= "registry.k8s.io/pause:3.10"|' | sudo tee /etc/containerd/config.toml
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
systemctl restart containerd