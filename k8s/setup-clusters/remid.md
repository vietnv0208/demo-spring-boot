# **Creating a cluster with kubeadm**

- Environment: Ubuntu/linux
- You need superuser access to the node.

### **Step 1: Prepare**

**1.1. [Optional] If you need to set up a cluster with multiple worker nodes<br>**

- Chuẩn bị sẵn các server: Thiết lập các cổng post và chọn mạng của security-group có thể gọi lẫn nhau ->
  config trên AWS Security Group<br>
- [Optional]: Đặt tên cho các server cho đễ phân biệt <br>
  Example:<br>

```sh
  sudo hostnamectl set-hostname master
  sudo reboot
  sudo hostnamectl set-hostname worker-01
  sudo reboot
  sudo hostnamectl set-hostname worker-02
  sudo reboot
```

- **1.2**. [<span style="color:red">Require</span>] Máy vật lý hay máy ảo cần chú ý không cấu hình DHCP ip (cần chuyển
  sang cấu hình tĩnh cho ip)**

### Step 2: Install tool

> **Run with root permission for all nodes**<br>

```sh
    sudo su -
    sh install-node.sh` #Config and install docker, kubelet, kubeadm, kubectl, socat, ...
```

### Step 3: Config node

- **3.a. Setup as a master node** <br>
  [continue as root permission] <br>
    - **3.a.1 kubeadm init**<br>

```sh
kubeadm init --apiserver-advertise-address <PRIVATE_IP_EC2> --pod-network-cidr 10.244.0.0/16 --cri-socket unix:///var/run/containerd/containerd.sock
```

Example:<br>

  ```sh
  kubeadm init --apiserver-advertise-address 192.168.1.222 --pod-network-cidr 10.244.0.0/16 --cri-socket unix:///var/run/containerd/containerd.sock
  ```

_#Please see the output of that command to know the join command._<br>

  ```sh
  exit
  ```

- **3.a.2 Start using your cluster**
    - To start using your cluster, you need to run the following as a regular user:<br>
  ```sh    
  mkdir -p $HOME/.kube
      sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      sudo chown $(id -u):$(id -g) $HOME/.kube/config
  ```

    - Or Alternatively, if you are the root user, you can run:<br>
  ```sh
    export KUBECONFIG=/etc/kubernetes/admin.conf
  ```


- **3.a.3 Installing a Pod network add-on**<br>
  If you want to change config please download file and modify before apply

  ```sh
  kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
  ```

    - **3.b. Worker node join to master node** <br>
      [continue as root permission] <br>
      You can now join any number of machines by running the following on each node as root:

      ```sh
        kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>
      ```

      Example:
        ```sh
      kubeadm join 192.168.1.222:6443 --token s5g2js.tpyonqwmakqhzhu1 \
      --discovery-token-ca-cert-hash sha256:8cd6c03eca67b34cfb185c84b294a1a4b8c4e2a8317ac67af98b250f30d845ce
        ```

## Done!!!

## Other

- If you do not have the token, you can get it by running the following command on the control plane node:

  ```sh
  # Run this on a control plane node 
  sudo kubeadm token list
  ```
- Lay token moi

- If you don't have the value of --discovery-token-ca-cert-hash, you can get it by running the following commands on the
  control plane node:

```sh
  #Run this on a control plane node
  sudo cat /etc/kubernetes/pki/ca.crt | openssl x509 -pubkey  | openssl rsa -pubin -outform der 2>/dev/null | \ 
  openssl dgst -sha256 -hex | sed 's/^.* //'
```  

### Get token list

```sh
kubeadm token list
```

### Create token

```sh
kubeadm token create
```

### Discovery token ca cert hash

```sh
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
openssl dgst -sha256 -hex | sed 's/^.* //'
```
