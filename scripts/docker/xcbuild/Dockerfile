# 基础镜像
FROM liuhong1happy/xcodecross
# 安装xcbuild
RUN useradd xcbuild && usermod -s /bin/bash xcbuild && mkdir /opt/xcbuild && usermod -d /opt/xcbuild xcbuild && su xcbuild
RUN apt-get install -y libpng-dev libpng16-16 libxml2-dev pkg-config ninja-build

RUN git clone https://gitee.com/mirrors/xcbuild && cd xcbuild && git checkout 57fe28235a72318b8266a1c4b9d4d0f10e2ff876 && git submodule sync && git submodule update --init
RUN mkdir xcbuild-build && mkdir /opt/xcbuild-install && cd xcbuild-build && cmake -DCMAKE_INSTALL_PREFIX=/opt/xcbuild-install -DCMAKE_BUILD_TYPE=Release ../xcbuild && make -j$(nproc) && make -j$(nproc) install
ENV PATH=$PATH:/opt/xcbuild-install/usr/bin
