#!/bin/bash
while [[ '1'='1' ]]; do
  echo "=================================================="
  echo "===============服务器环境部署-CentOS=============="
  echo "=================================================="
  echo "1.安装OpenJdk1.8"
  echo "2.安装Nginx"
  echo "3.安装Docker"
  echo "4.在Docker中安装Redis(需要先安装Docker)"
  echo "5.退出"
  read -p "请选择操作：" var

  if [[ ${var} -eq 1 ]]; then
    #安装OpenJdk1.8
    yum -y install java-1.8.0-openjdk.x86_64
  elif [[ ${var} -eq 2 ]]; then
    read -p "请输入Nginx安装路径(默认/usr/local/nginx)：" nginxPath
    #下载Nginx 1.12.2
    wget http://nginx.org/download/nginx-1.12.2.tar.gz
    # 安装依赖
    yum -y install gcc zlib zlib-devel pcre-devel openssl openssl-devel
    # 解压缩
    tar -zxvf nginx-1.12.2.tar.gz
    cd nginx-1.12.2/
    # 执行配置
    ./configure --prefix=${nginxPath:-/usr/local/nginx}
    # 编译安装(默认安装在/usr/local/nginx)
    make
    make install
    #软连接
    ln /usr/local/nginx/sbin/nginx /usr/bin/nginx
  elif [[ ${var} -eq 3 ]]; then
    #安装Docker 并启动
    yum -y install docker
    sudo systemctl start docker
  elif [[ ${var} -eq 4 ]]; then
    #启动Docker
    sudo systemctl start docker
    #在Docker中安装Redis 端口默认6379
    docker pull redis
    read -p "请输入Redis映射端口(默认6379)：" redisPort
    read -p "请输入Redis密码(请勿使用!)：" redisPwd
    docker run --name redis -p ${redisPort:-6379}:6379 -d redis --requirepass "${redisPwd}"
  elif [[ ${var} -eq 5 ]]; then
    #脚本退出
    exit 1
  else
    echo "输入错误"
  fi
done
