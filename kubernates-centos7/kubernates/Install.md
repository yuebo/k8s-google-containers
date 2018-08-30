安装docker
=============
## 配置系统

```bash
systemctl stop firewalld
systemctl disable firewalld
swapoff -a
```
## 关闭selinux

```bash
vi /etc/sysconfig/selinux
```
## 安装kubeadm

```bash
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
       http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable kubelet && systemctl start kubelet
 ```

## 下载镜像

```bash
docker pull mooncakexyb/kube-apiserver-amd64:v1.11.2
docker pull mooncakexyb/kube-controller-manager-amd64:v1.11.2
docker pull mooncakexyb/kube-scheduler-amd64:v1.11.2
docker pull mooncakexyb/kube-proxy-amd64:v1.11.2
docker pull mooncakexyb/pause:3.1
docker pull mooncakexyb/etcd-amd64:3.2.18
docker pull mooncakexyb/coredns:1.1.3
docker pull mooncakexyb/kubernetes-dashboard-amd64:v1.10.0

docker tag mooncakexyb/kube-apiserver-amd64:v1.11.2 k8s.gcr.io/kube-apiserver-amd64:v1.11.2
docker tag mooncakexyb/kube-controller-manager-amd64:v1.11.2 k8s.gcr.io/kube-controller-manager-amd64:v1.11.2
docker tag mooncakexyb/kube-scheduler-amd64:v1.11.2 k8s.gcr.io/kube-scheduler-amd64:v1.11.2
docker tag mooncakexyb/kube-proxy-amd64:v1.11.2 k8s.gcr.io/kube-proxy-amd64:v1.11.2
docker tag mooncakexyb/pause:3.1 k8s.gcr.io/pause:3.1
docker tag mooncakexyb/etcd-amd64:3.2.18 k8s.gcr.io/etcd-amd64:3.2.18
docker tag mooncakexyb/coredns:1.1.3 k8s.gcr.io/coredns:1.1.3
docker tag mooncakexyb/kubernetes-dashboard-amd64:v1.10.0 k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.0
```
## 初始化master

```bash
kubeadm init --kubernetes-version=1.11.2 --pod-network-cidr=10.244.0.0/16
```
## 配置KUBECONFIG

```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
```
## 配置flannel

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml
```

## 创建dashboard
```bash
kubectl create dashboard
```
## 获取token
```bash
kubectl -n kube-system get secret | grep kubernetes-dashboard-admin

```
## 生成客户端证书
 ```bash
grep 'client-certificate-data' /etc/kubernetes/admin.conf | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.crt
grep 'client-key-data' /etc/kubernetes/admin.conf | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.key
openssl pkcs12 -export -clcerts -inkey kubecfg.key -in kubecfg.crt -out kubecfg.p12 -name "kubernetes-client"
```
## 下载证书，安装并访问 
```http request
https://masternode:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
```
