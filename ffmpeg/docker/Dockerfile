FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget xz-utils

RUN wget https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_30MB.mp4 

RUN wget https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.2.1-amd64-static.tar.xz 

RUN tar -xvf ffmpeg-4.2.1-amd64-static.tar.xz \
    && cd ffmpeg-4.2.1-amd64-static \
    && mv ./ffmpeg /ffmpeg

COPY run_docker_side.sh /run.sh
ENTRYPOINT /run.sh