# Building Drone Recorder GoPRO container
###Recommendations:

This software is used on Raspberry PI ```ARM``` hardware platform and works directly with the GoPro camera. Currently Hero 3+ and Hero 4 models of this camera are recommended.

It is recommended to install this software after installing Drone Master Messenger product.

To install this product, you must have the following components:

- Docker 

Installation:

```Bash
curl -sSL https://get.docker.com | sh
```

- Git

Installation:

```Bash
sudo apt-get install git-core
```

These packages are sufficient to install this product.

###Stages of the project building:

Initially, you need to clone files from the repository:

```Bash
cd ~/
mkdir drone-recorder-gopro
git clone git@github.com:DroneEmployee/drone-recorder-gopro.git
```

And further it is necessary to build the container in ```Docker```

```Bash
docker build -t DroneEmployee/drone-recorder-gopro:armfh .
```

The process of building the container will take 2-3 minutes.

After the successful building, we check the state of the image:

```Bash
docker images
REPOSITORY                             TAG                 IMAGE ID            CREATED             SIZE
droneemployee/drone-recorder-gopro     armhf               b743a3fc1560        2 minute ago        1.06GB

```

Next, you need to update the page in the browser and you will be able to add the GoPro camera to ```drone-master-messenger```.
