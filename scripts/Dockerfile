# 基础镜像
FROM ubuntu:18.04
# 维护人员
MAINTAINER  liuhong1.happy@163.com
RUN useradd xcbuild && usermod -s /bin/bash xcbuild && mkdir /home/xcbuild && usermod -d /home/xcbuild xcbuild && su xcbuild
# 添加阿里云镜像源
RUN echo "deb http://mirrors.aliyun.com/ubuntu bionic main restricted universe multiverse" > /etc/apt/sources.list && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> /etc/apt/sources.list
# 更新apt源以及安装必要软件
RUN apt-get update && apt-get install -y curl vim git python gcc g++ make cmake ruby xz-utils inetutils-ping libssl-dev libtool automake
# 安装nodejs
RUN mkdir /data && cd /data && curl -O http://cdn.npm.taobao.org/dist/node/v12.5.0/node-v12.5.0-linux-x64.tar.xz &&  xz -d node-v12.5.0-linux-x64.tar.xz && tar xvf node-v12.5.0-linux-x64.tar
# 安装xcbuild
RUN apt-get install -y libpng-dev libpng16-16 libxml2-dev pkg-config ninja-build
RUN git clone --depth=1 https://github.com/facebook/xcbuild && cd xcbuild && git submodule update --init && make && mv build/xcbuild /usr/local/bin/
# 安装cocoapods
RUN gem install cocoapods
# 设置环境变量
ENV PATH "$PATH:/data/node-v12.5.0-linux-x64/bin/:/usr/local/bin/"
ENV LANG "C.UTF-8"
ENV LANGUAGE "C.UTF-8"
ENV LC_ALL "C.UTF-8"
# 安装yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# 构建ios工具链
RUN cd /data && curl -O https://qiniu.17ued.club/iPhoneOS12.2.sdk.tar.gz && git clone https://github.com/tpoechtrager/cctools-port.git 
RUN ./cctools-port/usage_examples/ios_toolchain/build.sh /data/iPhoneOS12.2.sdk.tar.gz arm7

# 拉取代码
RUN cd /data && git clone http://liuhong:12345678@192.168.2.201/xk-rn/xk-rn-merchant

# 参考 https://www.jianshu.com/p/d99995927527