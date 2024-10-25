Config Loadbalancer cho cluser co nhieu master node
Need:

- one server for lb
- some server for master node
- some server for worker node
### For loadbalancer server
**Install nginx**

```sh
    sudo su -
    sudo apt-get update
    sudo apt install -y nginx-full #to support stream
```

**Config loadbalancer**

```sh
    cd /etc/nginx
    mkdir k8s-lb.d
    cd k8s-lb.d
    nano apiserver.conf
```

**Input content:**

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
            #listen 443;
            proxy_pass kubernetes;
        }
    }
```

**Khai bao su dung conf**

```sh
nano /etc/nginx/nginx.conf
```

Bo sung dong sau vao cuoi file

```
    include /etc/nginx/k8s-lb.d/*.conf;
```
Or run command below:
```sh
echo 'include /etc/nginx/k8s-lb.d/*.conf;' | sudo tee -a /etc/nginx/nginx.conf
```

**Next run command:**

```sh
nginx -s reload
```

**[Optional] If you want use domain replace for lb_ip**<br>
Bo sung vao file host tren tat ca cac node(hoac su dung ip truc tiep cua node loadbalancer)

```sh
 sudo echo "<ip_node_config_lb> <domain_name>" >> /etc/hosts
```

Example:

    ```sh
    sudo echo "192.168.1.220 apiserver.lb" >> /etc/hosts
    ```

## Tren moi node master:
- Thuc hien setup node o huong dan setup node voi step 1&2 
### Init cluster

Chay truoc tren 1 node master de upload --upload-certs len truoc roi moi chay tiep cac node sau

```sh
kubeadm init --control-plane-endpoint=<ip_node_config_lb>:6443 --upload-certs --pod-network-cidr=<rangip>  --cri-socket unix:///var/run/containerd/containerd.sock
```

Example:

```sh
kubeadm init --control-plane-endpoint=apiserver.lb:6443 --upload-certs --pod-network-cidr=10.244.0.0/16 --cri-socket unix:///var/run/containerd/containerd.sock
```
Or
```sh
kubeadm init --control-plane-endpoint=192.168.1.220:6443 --upload-certs --pod-network-cidr=10.244.0.0/16 --cri-socket unix:///var/run/containerd/containerd.sock
```

Ket qua tra ve:
```text

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join 192.168.1.220:6443 --token q8qjw0.lgdojxisjd0saygg \
        --discovery-token-ca-cert-hash sha256:671fe93b6979fec7a52bb0688cb0646bb3f556edaa6a62745d50ab1c0dd10b25 \
        --control-plane --certificate-key 05c8d230f19c4d0e3e72ed22a14024c72fec354100cb9e6e70389b01fe92bffe

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.220:6443 --token q8qjw0.lgdojxisjd0saygg \
        --discovery-token-ca-cert-hash sha256:671fe93b6979fec7a52bb0688cb0646bb3f556edaa6a62745d50ab1c0dd10b25

```

**Thuc hien**
```shell
  exit
 ```
```shell
#To start using your cluster, you need to run the following as a regular user:
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

```
**Apply network**
  ```sh
  kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
  ```

**Add other master node -> join** 
```shell
  #You can now join any number of the control-plane node running the following command on each as root:
  kubeadm join 192.168.1.220:6443 --token q8qjw0.lgdojxisjd0saygg \
        --discovery-token-ca-cert-hash sha256:671fe93b6979fec7a52bb0688cb0646bb3f556edaa6a62745d50ab1c0dd10b25 \
        --control-plane --certificate-key 05c8d230f19c4d0e3e72ed22a14024c72fec354100cb9e6e70389b01fe92bffe

```

Output like below:
```text
This node has joined the cluster and a new control plane instance was created:

* Certificate signing request was sent to apiserver and approval was received.
* The Kubelet was informed of the new secure connection details.
* Control plane label and taint were applied to the new node.
* The Kubernetes control plane instances scaled up.
* A new etcd member was added to the local/stacked etcd cluster.

To start administering your cluster from this node, you need to run the following as a regular user:

        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config

Run 'kubectl get nodes' to see this node join the cluster.
```
**To start administering your cluster from this node, you need to run the following as a regular user:**
```shell
exit
```
```shell
        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### **Add worker node**
```shell
#Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.220:6443 --token q8qjw0.lgdojxisjd0saygg \
        --discovery-token-ca-cert-hash sha256:671fe93b6979fec7a52bb0688cb0646bb3f556edaa6a62745d50ab1c0dd10b25

```


### Loadbalancer for port serive
**Examp with node port 31000**
Add this bellow to k8s-lb.d file


```text
    # Upstream cho cổng 31000 (nếu các backend có cổng khác nhau)
    upstream kubernetes_31000 {
        server 192.168.1.221:31000 max_fails=3 fail_timeout=30s;
        server 192.168.1.222:31000 max_fails=3 fail_timeout=30s;
    }
    # Server block cho cổng 31000
    server {
        listen 31000;
        proxy_pass kubernetes_31000;
    }    
```
=>
```text
stream {
    # Upstream cho cổng 6443
    upstream kubernetes_6443 {
        server 192.168.1.221:6443 max_fails=3 fail_timeout=30s;
        server 192.168.1.222:6443 max_fails=3 fail_timeout=30s;
    }

    # Upstream cho cổng 31000 (nếu các backend có cổng khác nhau)
    upstream kubernetes_31000 {
        server 192.168.1.221:31000 max_fails=3 fail_timeout=30s;
        server 192.168.1.222:31000 max_fails=3 fail_timeout=30s;
    }

    # Server block cho cổng 6443
    server {
        listen 6443;
        proxy_pass kubernetes_6443;
    }

    # Server block cho cổng 31000
    server {
        listen 31000;
        proxy_pass kubernetes_31000;
    }
}


```
**apply config**
```sh
sudo nginx -s reload
```

## Done!

### Other

#### Get token list
```sh
kubeadm token list
```

#### Create token
```sh
kubeadm token create
```

#### Discovery token ca cert hash
```sh
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
openssl dgst -sha256 -hex | sed 's/^.* //'
```
