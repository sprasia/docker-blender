FROM ubuntu:bionic

RUN groupadd --gid 1000 blender \
  && useradd --uid 1000 --gid blender --shell /bin/bash --create-home blender \
  && apt-get update \
  && apt-get install -y \
        curl \
        git \
        bzip2 \
        ffmpeg \
        python3-pip \
        libfreetype6 \
        libgl1-mesa-dev \
        libglu1-mesa \
        libxi6 \
        libxrender1 \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

ENV BLENDER_MAJOR 2.80
ENV BLENDER_VERSION 2.80
ENV BLENDER_BZ2_URL https://mirror.clarkson.edu/blender/release/Blender$BLENDER_MAJOR/blender-$BLENDER_VERSION-linux-glibc217-x86_64.tar.bz2

RUN mkdir /usr/local/blender && \
    curl -SL "$BLENDER_BZ2_URL" -o blender.tar.bz2 && \
    tar -jxvf blender.tar.bz2 -C /usr/local/blender --strip-components=1 && \
    rm blender.tar.bz2 && \
    ln -s /usr/local/blender/blender /usr/bin/blender

USER blender

ENV YARN_DIR /home/blender/.yarn
ENV NVM_DIR /home/blender/.nvm
ENV NODE_VERSION 8.15.0

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $YARN_DIR/bin:$NVM_DIR/versions/node/v$NODE_VERSION/bin:/home/blender/.local/bin:${PATH}

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
RUN mkdir $NVM_DIR \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash \
    && /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use default && curl -o- -L https://yarnpkg.com/install.sh | bash" \
    && pip3 install --user bpsrender

VOLUME /media
