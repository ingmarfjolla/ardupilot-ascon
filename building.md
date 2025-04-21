# Build stuff

This isn't fully comprehensive and relies on ArduPilot / QGroundControl instructions mostly but will give you the gist on how to get started. 
## Pre reqs 
Make sure you've set up your environment to develop ArduPilot / QGC following their docs: 
- https://ardupilot.org/dev/docs/building-setup-linux.html
- https://docs.qgroundcontrol.com/master/en/qgc-dev-guide/getting_started/container.html 
- Also get Docker or Podman, that's what I use to build QGC. 

## Build ardupilot 
clone my repo from the pinned commit hash in the submodules directory [here](/submodules/). So to clone and buld ArduPilot run: 

```
git clone https://github.com/ingmarfjolla/ardupilot.git
cd ardupilot 
git checkout acb6ac79847c5583625d1703960dc34a9ab7b711
``` 
then build: 
```
./waf clean
./waf configure --board Pixhawk1
./waf copter 
```
Now you have the firmware built for your pixhawk. 

## Build QGC
```
git clone https://github.com/ingmarfjolla/qgroundcontrol.git
cd qgroundcontrol 
git checkout 3b79d46cc3541748325e34b0de7afd16c1819871
``` 
Then use docker to build it:

```
docker build --file ./deploy/docker/Dockerfile-build-ubuntu -t qgc-ubuntu-docker .
mkdir build
docker run --rm -v ${PWD}:/project/source -v ${PWD}/build:/project/build qgc-ubuntu-docker
```

## Upload firmware to pixhawk
Use QGroundControl to upload the firmware you just built in the ArduPilot steps onto your autopilot (in my case pixhawk). I followed these steps: https://docs.qgroundcontrol.com/master/en/qgc-user-guide/setup_view/firmware.html and made sure I did `advanced>custom firwmare file > choose the.bin file in the ardupilot/build/bin directory`. You should now have the firmware on your autopilot! Happy testing. 


## SITL 
After QGC is built to run SITL and do your testing the instructions are exactly the same as here: https://ardupilot.org/dev/docs/sitl-simulator-software-in-the-loop.html. I highly reccomend using Wireshark for log analysis while experimenting with SITL and using the lua plugin for mavlink. I have a prebuilt version in this repo [here](./docker/wireshark/mavlink_2_common.lua) or you can build it following the instructions on the mavlink website here: https://mavlink.io/en/guide/wireshark.html