FROM droneemployee/ros-base-armhf 

RUN apt-get update && apt-get install -y linux-firmware wpasupplicant dhcpcd5 wget sudo python-yaml python-pip libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev && pip install -U pip && pip install -U setuptools &&  pip install ipfsapi goprohero
RUN wget --no-check-certificate -O - -q https://dist.ipfs.io/go-ipfs/v0.4.10/go-ipfs_v0.4.10_linux-arm.tar.gz | tar xzv go-ipfs/ipfs && mv go-ipfs/ipfs /usr/bin/ipfs

ADD ./drone_recorder_gopro /tmp/build/src/drone_recorder_gopro
RUN . /opt/ros/kinetic/setup.sh \
    && cd /tmp/build/src \
    && catkin_init_workspace \
    && cd .. \
    && rosdep install --from-paths src --ignore-src --rosdistro=kinetic -y \
    && catkin_make

ADD ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
