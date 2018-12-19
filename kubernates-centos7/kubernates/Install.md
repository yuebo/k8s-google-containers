安装指南
=============
## 配置系统
```bash
sh prepare_env.hs
```
## 安装Docker
```bash
sh install_docker.sh
```
## 安装k8s
```bash
sh install_kubeadm.sh
```

## 导出证书
```bash
sh export_cert.sh
```

## 获取登录token
```bash
sh get_token.sh
```

## LoadBalancer 
kubectl run my-nginx --image=nginx --replicas=2 --port=80
kubectl  expose deployment my-nginx --name=my-nginx --type=LoadBalancer
## 测试
kubectl get svc
curl http://10.245.0.1