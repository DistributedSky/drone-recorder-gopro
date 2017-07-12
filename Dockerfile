FROM ros:kinetic-ros-base

RUN apt-get update && apt-get install -y linux-firmware wpasupplicant dhcpcd5 wget sudo python-yaml python-pip libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev && pip install ipfsapi goprohero
RUN wget --no-check-certificate -O - -q https://dist.ipfs.io/ipfs-update/v1.5.2/ipfs-update_v1.5.2_linux-amd64.tar.gz | tar xzv ipfs-update && ./ipfs-update/ipfs-update install latest 

ADD ./drone_recorder_gopro /tmp/build/src/drone_recorder_gopro
RUN . /opt/ros/kinetic/setup.sh \
    && cd /tmp/build/src \
    && catkin_init_workspace \
    && cd .. \
    && rosdep install --from-paths src --ignore-src --rosdistro=kinetic -y \
    && catkin_make

ADD ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
