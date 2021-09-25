ARCH=$(arch) && \
BRANCH="${BRANCH:-master}" && \
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/katacontainers:/releases:/${ARCH}:/${BRANCH}/xUbuntu_$(lsb_release -rs)/ /' > /etc/apt/sources.list.d/kata-containers.list" && \
curl -sL  http://download.opensuse.org/repositories/home:/katacontainers:/releases:/${ARCH}:/${BRANCH}/xUbuntu_$(lsb_release -rs)/Release.key | sudo apt-key add - && \
sudo -E apt-get update && \
sudo -E apt-get -y install kata-runtime kata-proxy kata-shim 


sudo mkdir -p /etc/docker

cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "runtimes": {
        "kata-runtime": {
            "path": "/usr/bin/kata-runtime"
        },
        "runsc": {
            "path": "/usr/bin/runsc"
        }
    }
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker