FROM --platform=linux/amd64 ubuntu:20.04

ENV ANSIBLE_HOST_KEY_CHECKING False

RUN apt update \
    && apt install -y gnupg wget software-properties-common \
    && apt-add-repository ppa:ansible/ansible \
    && wget -O- https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor | \
        tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && gpg --no-default-keyring \
        --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
        --fingerprint \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com/ $(lsb_release -cs) main" | \
        tee /etc/apt/sources.list.d/hashicorp.list \
    && apt update \
    && apt install -y ansible terraform \
    && apt install -y libvirt-clients \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "[defaults]" >> /etc/ansible/ansible.cfg \
    && echo "pipelining = True\n" >> /etc/ansible/ansible.cfg

RUN ansible-galaxy collection install community.general

CMD /bin/bash

