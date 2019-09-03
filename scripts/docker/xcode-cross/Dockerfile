# 基础镜像
FROM liuhong1happy/cctools

# xcode
ENV XCODE_URL="https://qiniu.17ued.club/xcbuild/xcode.tar.xz"
RUN apt-get install -y curl
RUN set -x \
  && curl -LO $XCODE_URL \
  && tar --warning=no-unknown-keyword -Jxf $(basename $XCODE_URL) \
  && rm $(basename $XCODE_URL)

ENV DEVELOPER_DIR=/opt/Xcode.app
# xcode-cross
RUN git clone https://github.com/Dockerlover/xcode-cross
RUN set -x \
  && cd Xcode.app \
  && /opt/xcode-cross/setup-toolchain.sh /opt/cctools /usr
# link
RUN /opt/xcode-cross/setup-symlinks.sh /opt/xcode-cross $DEVELOPER_DIR /opt/cctools
# 环境变量设置
ENV PATH=/opt/xcode-cross/bin:$PATH:$DEVELOPER_DIR/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:/opt/cctools/bin