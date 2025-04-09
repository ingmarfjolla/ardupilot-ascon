FROM lscr.io/linuxserver/wireshark:latest

COPY ./wireshark/mavlink_2_common.lua /usr/lib/wireshark/plugins