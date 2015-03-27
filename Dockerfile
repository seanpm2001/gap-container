FROM ubuntu:utopic

MAINTAINER GAP Project <support@gap-system.org>

RUN sudo apt-get update -qq \
    && sudo apt-get -qq install -y build-essential m4 libreadline6-dev libncurses5-dev wget \
    && adduser --quiet --shell /bin/bash --gecos "GAP user,101,," --disabled-password gap \
    && adduser gap sudo \
    && chown -R gap:gap /home/gap/ \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && mkdir -p /home/gap/inst \
    && chown -R gap:gap /home/gap/inst \
    && cd /home/gap/inst \
    && wget http://www.gap-system.org/pub/gap/gap47/tar.gz/gap4r7p7_2015_02_13-15_29.tar.gz \
    && tar xvzf gap4r7p7_2015_02_13-15_29.tar.gz \
    && cd gap4r7 \
    && ./configure --with-gmp=no \
    && make \
    && cd pkg/ace \
    && ./configure ../.. \
    && make \
    && cd ../anupq* \
    && ./configure \
    && make \
    && cd ../atlasrep \
    && chmod 1777 datagens dataword \
    && cd ../Browse \
    && ./configure \
    && make \
    && cd ../carat \
    && tar xzpf carat-2.1b1.tgz \
    && rm -f bin \
    && ln -s carat-2.1b1/bin bin \
    && cd carat-2.1b1/functions \
    && tar xzpf gmp-*.tar.gz \
    && cd .. \
    && make TOPDIR=`pwd` Links \
    && make TOPDIR=`pwd` Gmp \
    && make TOPDIR=`pwd` CFLAGS=`-O2` \
    && cd ../../cohomolo \
    && ./configure \
    && cd standalone/progs.d \
    && cd ../../ \
    && make \
    && cd ../cvec-* \
    && ./configure \
    && make \
    && cd ../edim \
    && ./configure \
    && make \
    && cd ../example \
    && ./configure ../.. \
    && make \
    && cd ../fplsa \
    && ./configure ../.. \
    && make CC="gcc -O2 " \
    && cd .. \
    && cd Gauss \
    && ./configure \
    && make \
    && cd ../grape \
    && ./configure ../.. \
    && make

# Set up new user and home directory in environment.
# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
USER gap
ENV HOME /home/gap
ENV GAP_HOME /home/gap/inst/gap4r7
ENV PATH ${GAP_HOME}/bin:${PATH}

# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]
