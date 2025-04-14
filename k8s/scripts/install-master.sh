#!/bin/bash

export API_ENDPOINT=192.168.10.2
export POD_CIDR=10.244.0.0/16
export USERNAME=vagrant
export GROUP=vagrant
export HOME_PATH=/home/$USERNAME
export K8S_VERSION=1.32

kubeadm init --apiserver-advertise-address $API_ENDPOINT --pod-network-cidr $POD_CIDR --upload-certs
mkdir -p $HOME_PATH/.kube
cp -i /etc/kubernetes/admin.conf $HOME_PATH/.kube/config
chown $USERNAME:$GROUP $HOME_PATH/.kube/config
su - $USERNAME -c "kubectl apply -f https://reweave.azurewebsites.net/k8s/v$K8S_VERSION/net.yaml"
echo -e 'alias k=kubectl\ncomplete -o default -F __start_kubectl k' >> $HOME_PATH/.bashrc
source $HOME_PATH/.bashrc