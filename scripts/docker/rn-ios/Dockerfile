FROM liuhong1happy/xcbuild
# 更新apt源以及安装必要软件
RUN apt-get update && apt-get install -y python ruby xz-utils
# 安装nodejs
RUN curl -OL http://cdn.npm.taobao.org/dist/node/v12.5.0/node-v12.5.0-linux-x64.tar.xz &&  xz -d node-v12.5.0-linux-x64.tar.xz && tar xvf node-v12.5.0-linux-x64.tar && rm node-v12.5.0-linux-x64.tar
# 环境变量
ENV PATH "$PATH:/opt/node-v12.5.0-linux-x64/bin/"
# 安装yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn
# 安装cocoapod
RUN gem install cocoapods
# 下载Specs仓库
RUN pod setup