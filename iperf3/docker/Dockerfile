FROM ubuntu:18.04

RUN apt update
RUN apt install -y libsctp1 wget
RUN wget https://iperf.fr/download/ubuntu/libiperf0_3.7-3_amd64.deb
RUN wget https://iperf.fr/download/ubuntu/iperf3_3.7-3_amd64.deb
RUN dpkg -i libiperf0_3.7-3_amd64.deb iperf3_3.7-3_amd64.deb
RUN rm libiperf0_3.7-3_amd64.deb iperf3_3.7-3_amd64.deb

EXPOSE 5201

ENTRYPOINT iperf3 -s -B 0.0.0.0
#can now run for example
#   iperf3 -c remotehost -i 1 -t 30 	Run a 30 second tests, giving results every 1 second
#   or reverse, with -R