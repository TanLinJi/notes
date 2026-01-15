###  原始步骤

服务器端是Ubuntu 22.04，使用的是humble版本，与狗端不兼容，需要运行在Docker容器内

#### 在T4中安装docker并设置Foxy镜像:

```bash
sudo apt update
# sudo apt install docker.io

sudo apt-get remove docker docker-engine docker.io containerd runc containerd.io # 彻底清理旧冲突

sudo apt-get autoremove
```

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add - # 添加阿里云 GPG 密钥
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" # 添加阿里云软件源
sudo apt-get update # 刷新源列表
sudo apt-get install -y docker-ce docker-ce-cli containerd.io # 安装docker-ce
```

```bash
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add - # 添加阿里云 GPG 密钥
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" # 添加阿里云Docker仓库

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io # 安装docker-ce

sudo systemctl start docker
sudo systemctl enable docker # 启动docker

sudo usermod -aG docker $USER
newgrp docker # 设置免sudo权限

docker run hello-world # 验证docker是否正常工作

```

如果报错或者最后一步卡住 `Unable to find image 'hello-world:latest' locally`，需要配置Docker的国内镜像加速器：

```bash
# 1.写入配置
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": [
        "https://docker.m.daocloud.io",
        "https://docker.1panel.live",
        "https://hub.rat.dev"
    ]
}
EOF
```

```bash
# 2.重启 Docker 服务让配置生效
sudo systemctl daemon-reload
sudo systemctl restart docker
```

```bash
# 3.再次验证
docker run hello-world
```

```bash
# 4.重新拉取ROS2 Foxy镜像
docker pull osrf/ros:foxy-desktop
```

```bash
#5.  启动容器
# --net=host: 让容器和宿主机共用网络
# -v: 把服务器上的代码文件夹映射到容器里的 /root/code 目录
# -it: 启动交互式终端
docker run -it --net=host -v /home/jitl/PoliFormer:/root/code osrf/ros:foxy-desktop
```

启动容器后：行完第 2 步后，命令行提示符会从 `(base) jitl@cloudos-gpu-1:~$` 变成：`root@cloudos-gpu-1:/#`，说明已经进入到docker容器中。

#### 配置docker环境（T4端设置）

```bash
# 1.更新源并安装依赖工具
apt update
apt install -y python3-opencv ros-foxy-rmw-cyclonedds-cpp nano
```

```bash
# 2.设置通信配置文件
# 写入服务器端的配置文件（IP设置为狗的IP）
echo '<?xml version="1.0" encoding="UTF-8" ?>
<CycloneDDS>
    <Domain>
        <General>
            <AllowMulticast>false</AllowMulticast>
        </General>
        <Discovery>
            <Peers>
                <Peer address="10.11.2.201"/>
            </Peers>
            <ParticipantIndex>auto</ParticipantIndex>
        </Discovery>
    </Domain>
</CycloneDDS>' > /root/server_dds.xml
```

```bash
# 3. 加载环境并配应用配置
# 3.1 加载 ROS 2 Foxy 环境
source /opt/ros/foxy/setup.bash

# 3.2 设置 Domain ID (必须和狗一致，通常是 10)
export ROS_DOMAIN_ID=10

# 3.3 指定使用 CycloneDDS 中间件
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# 3.4 加载刚才生成的配置文件
export CYCLONEDDS_URI=file:///root/server_dds.xml
```

```bash
# 4.启动接收脚本
cd /root/code
# 运行后，它会进入等待状态，不会有报错，光标闪烁是正常的
python3 ros2_image_receiver.py
```

#### 配置机器狗端环境

```bash
# 1.设置狗端跨网段配置文件
echo '<?xml version="1.0" encoding="UTF-8" ?>
<CycloneDDS>
    <Domain>
        <General>
            <NetworkInterfaceAddress>wlan0</NetworkInterfaceAddress>
            <AllowMulticast>false</AllowMulticast>
        </General>
        <Discovery>
            <Peers>
                <Peer address="10.10.4.179"/>
            </Peers>
            <ParticipantIndex>auto</ParticipantIndex>
        </Discovery>
    </Domain>
</CycloneDDS>' > ~/send_img_dds.xml
```

```bash
# 2. 加载环境并发送
# 2.1 基础环境
source /opt/ros/foxy/setup.bash

# 2.2 必须一致的 Domain ID
export ROS_DOMAIN_ID=10

# 2.3 指定中间件
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# 2.4 加载配置文件
export CYCLONEDDS_URI=file:///home/unitree/send_img_dds.xml

# 2.5 启动发送脚本 (务必使用系统 Python)
/usr/bin/python3 /home/unitree/PoliFormer/ros2_sender_file.py
```



### 总结

#### 准备工作

`ip addr`获取两边IP，确保在同一个局域网内：

- **T4 服务器 IP (Server_IP):** `10.10.4.179`
- **机器狗 IP (Dog_IP):** `10.11.2.201`

#### 服务器端（T4）:

- 在 Ubuntu 22.04 上安装 Docker，配置 ROS 2 Foxy 环境，打通防火墙，准备接收

  ```bash
  # 1. 清理旧版本冲突
  sudo apt-get remove docker docker-engine docker.io containerd runc
  sudo apt-get autoremove
  
  # 2. 安装基础工具
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  
  # 3. 添加阿里云 GPG 密钥
  curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
  
  # 4. 添加阿里云软件源
  sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
  
  # 5. 更新并安装 Docker CE
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  
  # 6. 配置免 sudo 权限
  sudo usermod -aG docker $USER
  newgrp docker
  
  # 7. 配置镜像加速 (解决拉取卡死问题)
  sudo mkdir -p /etc/docker
  sudo tee /etc/docker/daemon.json <<-'EOF'
  {
      "registry-mirrors": [
          "https://docker.m.daocloud.io",
          "https://docker.1panel.live"
      ]
  }
  EOF
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  ```

- 为进行跨网段 UDP 通信，必须在**宿主机**暂时关闭防火墙：

  ```bash
  sudo ufw disable
  sudo iptables -F
  ```

- 启动ros2 Foxy环境

  ```bash
  # 拉取镜像
  docker pull osrf/ros:foxy-desktop
  
  # 启动容器 (--net=host 是核心)
  docker run -it --net=host -v /home/jitl/PoliFormer:/root/code osrf/ros:foxy-desktop
  ```

- 配置容器通信XML文件(server_dds.xml)

  进入容器后 (`root@...`)，创建配置文件。
  **注意：** `<Peer>` 必须填**机器狗**的 IP。

  ```bash
  echo '<?xml version="1.0" encoding="UTF-8" ?>
  <CycloneDDS>
      <Domain>
          <General>
              <AllowMulticast>false</AllowMulticast>
              <MaxMessageSize>1400</MaxMessageSize> <FragmentSize>1200</FragmentSize>
          </General>
          <Discovery>
              <Peers>
                  <Peer address="10.11.2.201"/>
              </Peers>
              <ParticipantIndex>auto</ParticipantIndex>
          </Discovery>
      </Domain>
  </CycloneDDS>' > /root/server_dds.xml
  ```

- ros2_image_receiver.py

- 启动接收

  ```bash
  source /opt/ros/foxy/setup.bash
  export ROS_DOMAIN_ID=10
  export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
  export CYCLONEDDS_URI=file:///root/server_dds.xml
  cd /root/code
  
  # 补装依赖 (CycloneDDS + OpenCV)
  apt update
  apt install -y ros-foxy-rmw-cyclonedds-cpp python3-opencv
  
  python3 ros2_image_receiver.py
  ```

#### 机器狗端（Go2）:

避开 Conda 环境干扰，强制走 WiFi 防止崩溃，解决跨网段

- 清理环境

  ```bash
  conda deactivate
  # 或者直接用
  /bin/bash --norc
  ```

- 配置通信 XML (safe_dds.xml)

  **注意：** `<NetworkInterfaceAddress>` 必须是 `wlan0`，`<Peer>` 必须填**服务器**的 IP。

  ```bash
  echo '<?xml version="1.0" encoding="UTF-8" ?>
  <CycloneDDS>
      <Domain>
          <General>
              <NetworkInterfaceAddress>wlan0</NetworkInterfaceAddress>
              <AllowMulticast>false</AllowMulticast>
              <MaxMessageSize>1400</MaxMessageSize> <FragmentSize>1200</FragmentSize>
          </General>
          <Discovery>
              <Peers>
                  <Peer address="10.10.4.179"/>
              </Peers>
              <ParticipantIndex>auto</ParticipantIndex>
          </Discovery>
      </Domain>
  </CycloneDDS>' > ~/safe_dds.xml
  ```

- ros2_sender_file.py

- 启动发送

  ```bash
  source /opt/ros/foxy/setup.bash
  export ROS_DOMAIN_ID=10
  export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
  export CYCLONEDDS_URI=file:///home/unitree/safe_dds.xml
  
  # 运行
  /usr/bin/python3 /home/unitree/PoliFormer/ros2_sender_file.py
  ```

  

### 其他

IP地址：

T4:

```text
IPv4 地址：10.10.4.179

IPv6 地址：240c:c983:5:631a::acb
```

Unitree:

```text
IPV4地址：10.11.3.219
```

在狗上，通过ipp addr命令，后：

```
7: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 6c:1f:f7:4b:b6:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.11.3.219/22 brd 10.11.3.255 scope global dynamic noprefixroute wlan0
       valid_lft 6839sec preferred_lft 6839sec
    inet6 fe80::761b:abc6:4a80:c27/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```

其中Wlan的 inet就是狗的IP



1. 192.168.31.86 这是xiaomiGo2的网段
2. 通过命令:

```
sudo nmcli con up "icct"
sudo route delete -net 0.0.0.0 gw 192.168.123.1
```

3. 然后就切换到了ICCT的网段

详细命令：

```bash
ros:foxy(1) noetic(2) ?
1
😾 未检测到代理变量，可执行 clashon 开启代理环境
[sudo] password for unitree: 
😼 已开启代理环境

(poliformer) unitree@ubuntu:~$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 4e:6a:78:71:94:fc brd ff:ff:ff:ff:ff:ff
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 3c:6d:66:2b:f2:dc brd ff:ff:ff:ff:ff:ff
    altname enP8p1s0
    inet 192.168.123.18/24 brd 192.168.123.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::d150:4901:5a1a:cb5/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: l4tbr0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 1a:da:05:a7:b3:ed brd ff:ff:ff:ff:ff:ff
5: rndis0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast master l4tbr0 state DOWN group default qlen 1000
    link/ether 1a:da:05:a7:b3:ed brd ff:ff:ff:ff:ff:ff
6: usb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast master l4tbr0 state DOWN group default qlen 1000
    link/ether 1a:da:05:a7:b3:ef brd ff:ff:ff:ff:ff:ff
7: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 6c:1f:f7:4b:b6:e6 brd ff:ff:ff:ff:ff:ff
    inet 192.168.31.86/24 brd 192.168.31.255 scope global dynamic noprefixroute wlan0
       valid_lft 41638sec preferred_lft 41638sec
    inet6 fe80::f1a0:bac9:6d47:4921/64 scope link dadfailed tentative noprefixroute 
       valid_lft forever preferred_lft forever
    inet6 fe80::c423:8786:d5da:e8a8/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
8: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:af:cf:20:f5 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
       
(poliformer) unitree@ubuntu:~$ sudo nmcli con up "icct"
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/4)




(poliformer) unitree@ubuntu:~$ sudo route delete -net 0.0.0.0 gw 192.168.123.1
(poliformer) unitree@ubuntu:~$ ping 10.10.4.179
PING 10.10.4.179 (10.10.4.179) 56(84) bytes of data.
64 bytes from 10.10.4.179: icmp_seq=1 ttl=62 time=2.90 ms
64 bytes from 10.10.4.179: icmp_seq=2 ttl=62 time=2.20 ms
64 bytes from 10.10.4.179: icmp_seq=3 ttl=62 time=77.3 ms
^C
--- 10.10.4.179 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 2.197/27.462/77.292/35.236 ms


(poliformer) unitree@ubuntu:~$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 4e:6a:78:71:94:fc brd ff:ff:ff:ff:ff:ff
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 3c:6d:66:2b:f2:dc brd ff:ff:ff:ff:ff:ff
    altname enP8p1s0
    inet 192.168.123.18/24 brd 192.168.123.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::d150:4901:5a1a:cb5/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: l4tbr0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 1a:da:05:a7:b3:ed brd ff:ff:ff:ff:ff:ff
5: rndis0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast master l4tbr0 state DOWN group default qlen 1000
    link/ether 1a:da:05:a7:b3:ed brd ff:ff:ff:ff:ff:ff
6: usb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast master l4tbr0 state DOWN group default qlen 1000
    link/ether 1a:da:05:a7:b3:ef brd ff:ff:ff:ff:ff:ff
7: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 6c:1f:f7:4b:b6:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.11.3.219/22 brd 10.11.3.255 scope global dynamic noprefixroute wlan0
       valid_lft 6839sec preferred_lft 6839sec
    inet6 fe80::761b:abc6:4a80:c27/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
8: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:af:cf:20:f5 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
(poliformer) unitree@ubuntu:~$ ping 10.10.4.179
PING 10.10.4.179 (10.10.4.179) 56(84) bytes of data.
64 bytes from 10.10.4.179: icmp_seq=1 ttl=62 time=7.16 ms
64 bytes from 10.10.4.179: icmp_seq=2 ttl=62 time=2.83 ms
64 bytes from 10.10.4.179: icmp_seq=3 ttl=62 time=2.65 ms
^C
--- 10.10.4.179 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 2.653/4.213/7.155/2.081 ms
```

在服务器上：

```bash
(base) jitl@cloudos-gpu-1:~$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether fe:fc:fe:d3:c9:df brd ff:ff:ff:ff:ff:ff
    altname enp0s18
    inet 10.10.4.179/16 brd 10.10.255.255 scope global ens18
       valid_lft forever preferred_lft forever
    inet6 240c:c983:5:631a::acb/128 scope global dynamic noprefixroute 
       valid_lft 7047sec preferred_lft 7047sec
    inet6 240c:c983:5:631a:fcfc:feff:fed3:c9df/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 245967sec preferred_lft 159567sec
    inet6 fe80::fcfc:feff:fed3:c9df/64 scope link 
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether da:9c:62:d3:e5:a9 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
4: br-8e489b0de33b: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether ea:02:f3:9b:a3:13 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.1/16 brd 172.18.255.255 scope global br-8e489b0de33b
       valid_lft forever preferred_lft forever
    inet6 fe80::e802:f3ff:fe9b:a313/64 scope link 
       valid_lft forever preferred_lft forever
5: br-93864f7a5f1a: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether ee:6f:7d:09:c0:3e brd ff:ff:ff:ff:ff:ff
    inet 172.19.0.1/16 brd 172.19.255.255 scope global br-93864f7a5f1a
       valid_lft forever preferred_lft forever
    inet6 fe80::ec6f:7dff:fe09:c03e/64 scope link 
       valid_lft forever preferred_lft forever
6: veth8b3afe0@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-93864f7a5f1a state UP group default 
    link/ether 76:17:02:e0:83:b2 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::7417:2ff:fee0:83b2/64 scope link 
       valid_lft forever preferred_lft forever
7: veth6513e05@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e489b0de33b state UP group default 
    link/ether 52:6a:31:d3:24:07 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet6 fe80::506a:31ff:fed3:2407/64 scope link 
       valid_lft forever preferred_lft forever
8: veth675a9c3@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e489b0de33b state UP group default 
    link/ether 9e:f3:2b:5e:14:46 brd ff:ff:ff:ff:ff:ff link-netnsid 2
    inet6 fe80::9cf3:2bff:fe5e:1446/64 scope link 
       valid_lft forever preferred_lft forever
9: veth90955af@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-93864f7a5f1a state UP group default 
    link/ether 72:2c:c3:35:55:2b brd ff:ff:ff:ff:ff:ff link-netnsid 3
    inet6 fe80::702c:c3ff:fe35:552b/64 scope link 
       valid_lft forever preferred_lft forever
10: veth0955bbb@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e489b0de33b state UP group default 
    link/ether 6e:e7:f4:dc:74:7b brd ff:ff:ff:ff:ff:ff link-netnsid 4
    inet6 fe80::6ce7:f4ff:fedc:747b/64 scope link 
       valid_lft forever preferred_lft forever
11: vethf4ddde9@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e489b0de33b state UP group default 
    link/ether 7e:00:68:f4:1a:24 brd ff:ff:ff:ff:ff:ff link-netnsid 5
    inet6 fe80::7c00:68ff:fef4:1a24/64 scope link 
       valid_lft forever preferred_lft forever
12: veth991e970@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-93864f7a5f1a state UP group default 
    link/ether d6:80:10:50:77:da brd ff:ff:ff:ff:ff:ff link-netnsid 2
    inet6 fe80::d480:10ff:fe50:77da/64 scope link 
       valid_lft forever preferred_lft forever
13: veth668cc0e@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e489b0de33b state UP group default 
    link/ether 26:0c:02:a0:a1:76 brd ff:ff:ff:ff:ff:ff link-netnsid 6
    inet6 fe80::240c:2ff:fea0:a176/64 scope link 
       valid_lft forever preferred_lft forever
14: vethcc16f97@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e489b0de33b state UP group default 
    link/ether c6:f7:03:bc:2b:88 brd ff:ff:ff:ff:ff:ff link-netnsid 7
    inet6 fe80::c4f7:3ff:febc:2b88/64 scope link 
       valid_lft forever preferred_lft forever
15: veth7385a86@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-93864f7a5f1a state UP group default 
    link/ether be:c0:2f:58:28:59 brd ff:ff:ff:ff:ff:ff link-netnsid 5
    inet6 fe80::bcc0:2fff:fe58:2859/64 scope link 
       valid_lft forever preferred_lft forever
16: veth1382c0b@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e489b0de33b state UP group default 
    link/ether 2e:0a:7d:98:1d:30 brd ff:ff:ff:ff:ff:ff link-netnsid 8
    inet6 fe80::2c0a:7dff:fe98:1d30/64 scope link 
       valid_lft forever preferred_lft forever
17: vethc165a4a@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e489b0de33b state UP group default 
    link/ether 4e:c6:87:08:66:6c brd ff:ff:ff:ff:ff:ff link-netnsid 9
    inet6 fe80::4cc6:87ff:fe08:666c/64 scope link 
       valid_lft forever preferred_lft forever
18: veth2136b58@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e489b0de33b state UP group default 
    link/ether 1e:1b:03:2e:ad:fa brd ff:ff:ff:ff:ff:ff link-netnsid 10
    inet6 fe80::1c1b:3ff:fe2e:adfa/64 scope link 
       valid_lft forever preferred_lft forever
19: veth933c70b@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e489b0de33b state UP group default 
    link/ether 2e:a0:2c:6c:97:5f brd ff:ff:ff:ff:ff:ff link-netnsid 3
    inet6 fe80::2ca0:2cff:fe6c:975f/64 scope link 
       valid_lft forever preferred_lft forever
20: veth763ec45@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-93864f7a5f1a state UP group default 
    link/ether 6a:a6:b9:bb:ef:f1 brd ff:ff:ff:ff:ff:ff link-netnsid 9
    inet6 fe80::68a6:b9ff:febb:eff1/64 scope link 
       valid_lft forever preferred_lft forever
(base) jitl@cloudos-gpu-1:~$ ping 10.11.3.219
PING 10.11.3.219 (10.11.3.219) 56(84) bytes of data.
64 bytes from 10.11.3.219: icmp_seq=1 ttl=62 time=4.00 ms
64 bytes from 10.11.3.219: icmp_seq=2 ttl=62 time=3.53 ms
64 bytes from 10.11.3.219: icmp_seq=3 ttl=62 time=2.62 ms
64 bytes from 10.11.3.219: icmp_seq=4 ttl=62 time=3.07 ms
^C
--- 10.11.3.219 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 2.617/3.304/3.997/0.514 ms
(base) jitl@cloudos-gpu-1:~$ 
```



配置了IPV4:

![1766219505783](ros2%E9%80%9A%E4%BF%A1.assets/1766219505783.png)





