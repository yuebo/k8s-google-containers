安装指南
=============
## 配置系统

```bash
systemctl stop firewalld
systemctl disable firewalld
swapoff -a
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/bridge/bridge-nf-call-ip6tables

```
## 关闭selinux

```bash
vi /etc/sysconfig/selinux
```

## 安装docker

* Docker 的 安装资源文件 存放在Amazon S3，会间歇性连接失败。所以安装Docker的时候，会比较慢。 
* 你可以通过执行下面的命令，高速安装Docker。

```bash
    curl -sSL https://get.daocloud.io/docker | sh
```

* 你可以使用以下命令来卸载

```bash
    sudo apt-get remove docker docker-engine
```

* 卸载Docker后,/var/lib/docker/目录下会保留原Docker的镜像,网络,存储卷等文件. 如果需要全新安装Docker,需要删除/var/lib/docker/目录

```bash
    rm -fr /var/lib/docker/
```   
 
### 安装 Docker Compose

* Docker Compose 存放在Git Hub，不太稳定。 
* 你可以也通过执行下面的命令，高速安装Docker Compose。

```bash
    curl -L https://get.daocloud.io/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
```
#### Docker 加速器

* Docker镜像服务器在国外，会导致访问很慢，可以使用以下命令来设置加速器

```bash
    curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://e7850958.m.daocloud.io
```

```bash
systemctl enable docker
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
docker tag mooncakexyb/kube-apiserver-amd64:v1.13.0 k8s.gcr.io/kube-apiserver:v1.13.0
docker tag mooncakexyb/kube-controller-manager-amd64:v1.13.0 k8s.gcr.io/kube-controller-manager:v1.13.0
docker tag mooncakexyb/kube-scheduler-amd64:v1.13.0 k8s.gcr.io/kube-scheduler:v1.13.0
docker tag mooncakexyb/kube-proxy-amd64:v1.13.0 k8s.gcr.io/kube-proxy:v1.13.0
docker tag mooncakexyb/pause:3.1 k8s.gcr.io/pause:3.1
docker tag mooncakexyb/etcd-amd64:3.2.24 k8s.gcr.io/etcd:3.2.24
docker tag mooncakexyb/coredns:1.2.6 k8s.gcr.io/coredns:1.2.6
docker tag mooncakexyb/kubernetes-dashboard-amd64:v1.10.0 k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.0```
## 初始化master

```bash
kubeadm init --kubernetes-version=1.13.0 --pod-network-cidr=10.244.0.0/16
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
kubectl create -f dashboard
```
## 获取token
```bash
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep kubernetes-dashboard-token|awk '{print $1}')|grep token:|awk '{print $2}'
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

## 允许master部署taint
kubectl taint nodes --all node-role.kubernetes.io/master-



## 开启LoadBalancer支持
* 编辑 /etc/kubernetes/manifests/kube-controller-manager.yaml

```
spec:
  containers:
  - command:
    - kube-controller-manager
    - --cloud-provider=external
```


## LoadBalancer 
kubectl run my-nginx --image=nginx --replicas=2 --port=80
kubectl  expose deployment my-nginx --name=my-nginx --type=LoadBalancer
## 测试
kubectl get svc
curl http://10.245.0.1