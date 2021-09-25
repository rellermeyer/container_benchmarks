FROM rust:1.40.0

COPY / /

RUN git clone https://github.com/intel/cloud-hypervisor.git
WORKDIR /cloud-hypervisor
RUN git checkout 52b839694deaf4dfedaa29c452e6ccf40f7bf467 

RUN cargo build --release

RUN mkdir -p /res
RUN cp target/release/cloud-hypervisor /res

ENTRYPOINT cp -r /res/* /out
