# **Creating a cluster with kubeadm**
- Environment: Ubuntu/linux
- You need superuser access to the node.

### **Step 1: Prepare**

**1.1. [Optional] If you need to set up a cluster with multiple worker nodes<br>**
- Chuẩn bị sẵn các server: Thiết lập các cổng post và chọn mạng của security-group có thể gọi lẫn nhau -> config trên AWS Security Group<br>
-  [Optional]: Đặt tên cho các server cho đễ phân biệt <br>
  Example:<br>
  `sudo hostnamectl set-hostname master`<br>
  `sudo reboot`<br><br>
  `sudo hostnamectl set-hostname worker-01`<br>
  `sudo reboot`<br><br>
  `sudo hostnamectl set-hostname worker-02`<br>
  `sudo reboot`<br>


- **1.2**. [<span style="color:red">Require</span>] Máy vật lý hay máy ảo cần chú ý không cấu hình DHCP ip (cần chuyển sang cấu hình tĩnh cho ip)**

### Step 2: Install tool
 >**Run with root permission for all nodes**<br>
    `sudo su -`
    <br>
    `sh install-node.sh` _#Config and install docker, kubelet, kubeadm, kubectl, socat, ..._

### Step 3: Config node
- **3.a. Setup as a master node** <br>
[continue as root permission] <br>
    - **3.a.1 kubeadm init**<br>
`kubeadm init --apiserver-advertise-address <PRIVATE_IP_EC2> --pod-network-cidr 10.244.0.0/16 --cri-socket unix:///var/run/containerd/containerd.sock`<br>

  _#Please see the output of that command to know the join command._

  `exit`<br>

  - **3.a.2 Start using your cluster**
    - To start using your cluster, you need to run the following as a regular user:<br>
    `mkdir -p $HOME/.kube`<br>
    `sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config`<br>
    `sudo chown $(id -u):$(id -g) $HOME/.kube/config`<br>
    - Or Alternatively, if you are the root user, you can run:<br>
    `export KUBECONFIG=/etc/kubernetes/admin.conf`

    Example:<br>
    `kubeadm init --apiserver-advertise-address 192.168.1.222 --pod-network-cidr 10.244.0.0/16 --cri-socket unix:///var/run/containerd/containerd.sock`

  - **3.a.3 Installing a Pod network add-on**<br>
  If you want to change config please download file and modify before apply

  `kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml`

- **3.b. Worker node join to master node** <br>
[continue as root permission] <br>
You can now join any number of machines by running the following on each node as root:

    `kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>`<br>

    Example:<br>
  `kubeadm join 192.168.1.222:6443 --token s5g2js.tpyonqwmakqhzhu1 \
--discovery-token-ca-cert-hash sha256:8cd6c03eca67b34cfb185c84b294a1a4b8c4e2a8317ac67af98b250f30d845ce`

## Done!!!
  

## Other

  - If you do not have the token, you can get it by running the following command on the control plane node:

  `# Run this on a control plane node`<br>
   `sudo kubeadm token list`
  - If you don't have the value of --discovery-token-ca-cert-hash, you can get it by running the following commands on the control plane node:

  `# Run this on a control plane node`<br>
  `sudo cat /etc/kubernetes/pki/ca.crt | openssl x509 -pubkey  | openssl rsa -pubin -outform der 2>/dev/null | \ ` <br>
  `openssl dgst -sha256 -hex | sed 's/^.* //'`