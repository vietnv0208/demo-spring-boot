Config Loadbalancer cho cluser co nhieu master node
Need:

- one server for lb
- some server for master node
- some server for worker node

Install nginx

```sh
    sudo su -i
    sudo apt-get update
    sudo apt install -y nginx-full #to support stream
```

Config loadbalancer

```sh
    cd /etc/nginx
    mkdir k8s-lb.d
    cd k8s-lb.d
    nano apiserver.conf
```

Input content:

```    
stream {
    upstream kubernetes {
        server master1_ip:6443 max_fails=3 fail_timeout=30s;
        server master2_ip:6443 max_fails=3 fail_timeout=30s;
        server master3_ip:6443 max_fails=3 fail_timeout=30s;
    }
server {
        listen 6443;
        listen 443;
        proxy_pass kubernetes;
    }
}
```

Example:

```
    stream {
        upstream kubernetes {
            server 192.168.1.221:6443 max_fails=3 fail_timeout=30s;
            server 192.168.1.222:6443 max_fails=3 fail_timeout=30s;
        }
    server {
            listen 6443;
            #listen 31000;
            proxy_pass kubernetes;
        }
    }
```

Khai bao su dung conf

```sh
nano /etc/nginx/nginx.conf
```

Bo sung dong sau vao cuoi file

```
    include /etc/nginx/k8s-lb.d/*.conf;
```

chay lenh:

```sh
nginx -s reload
```

Bo sung vao file host tren tat ca cac node

```sh
 sudo echo "<ip_node_config_lb> <domain_name>" >> /etc/hosts
```

Example:

```sh
sudo echo "192.168.1.220 apiserver.lb" >> /etc/hosts
```

# Tren moi node master:

## Init cluster

Chay truoc tren 1 node master de upload --upload-certs len truoc roi moi chay tiep cac node sau

```sh
kubeadm init --control-plane-endpoint=<ip_node_config_lb>:6443 --upload-certs --pod-network-cidr=<rangip>
```

Example:

```sh
kubeadm init --control-plane-endpoint=apiserver.lb:6443 --upload-certs --pod-network-cidr=10.244.0.0/16
```
