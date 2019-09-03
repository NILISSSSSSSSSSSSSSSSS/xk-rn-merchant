# 基础镜像
FROM liuhong1happy/clang

WORKDIR /opt

RUN apt-get install -y git cmake g++ gcc

# 构建ios工具链
# 1. libtapis
ENV INSTALLPREFIX=/opt/cctools
RUN git clone https://gitee.com/liuhong1happy/apple-libtapi 
RUN cd apple-libtapi  && ./build.sh  && ./install.sh && cd .. && rm -r apple-libtapi

# 2. cctools-port
RUN git clone https://gitee.com/liuhong1happy/cctools-port.git 

ADD lnclang7.sh .
RUN bash ./lnclang7.sh

RUN cd cctools-port/cctools  \
  && CFLAGS="-D_FORTIFY_SOURCE=0 -O3" CC=clang CXX=clang++ ./configure --prefix=$INSTALLPREFIX --with-libtapi=$INSTALLPREFIX \
  && make -j$(nproc) && make -j$(nproc) install && cd ../.. && rm -rf cctools-port