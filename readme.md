# ArduPilot x Ascon

This repo holds the work I have on adding Ascon(https://csrc.nist.gov/csrc/media/Presentations/2023/the-ascon-family/images-media/june-21-mendel-the-ascon-family.pdf) encryption of the mavlink payload to ArduPilot and QGroundControl. It's mainly a proof of concept and is not production ready nor does it uphold security properties since a couple of messages are not being encrypted and the nonce is currently hardcoded just to make this POC work.  

To clone this repo and all it's submodules, run `git clone --recurse-submodules https://github.com/ingmarfjolla/ardupilot-ascon.git`.

## Building 
For build instructions, see [build guide](building.md). There is also the docker option [here](/docker/readme.md) but only seems to work on linux and potentially WSL. I haven't been able to make this project work on an arm mac unfortunately. 

## Performance 
I did some analysis using Mission Planner and compared some of the dataflash logs [here](/assets/loganalysis/) using versions of ArduCopter with and without encryption. The encrypted version is on top in those images. The drone was mainly armed and in stabalize / altitude hold and didn't really see flight. A lot of the testing was done mainly using SITL. 
 
### Credits 
Many thanks to these repos and papers that pointed me in the correct direction along with the ArduPilot folks for answering my questions in their discord! 
- https://github.com/angelopassaro/SEC-UAV?tab=readme-ov-file
- https://link.springer.com/chapter/10.1007/978-3-031-37120-2_7 
- https://github.com/aniskoubaa/mavsec 
- https://github.com/ascon/ascon-c 