FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl gnupg sudo openssh-server netcat-openbsd \
    python3 net-tools procps iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Add Wazuh repo
RUN curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH \
    | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import \
    && chmod 644 /usr/share/keyrings/wazuh.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" \
    > /etc/apt/sources.list.d/wazuh.list

RUN apt-get update && \
    WAZUH_MANAGER=wazuh.manager \
    WAZUH_AGENT_NAME=ubuntu-victim \
    apt-get install -y wazuh-agent \
    && rm -rf /var/lib/apt/lists/*

# Set up SSH for brute-force demo
RUN mkdir /var/run/sshd && \
    useradd -m -s /bin/bash labuser && \
    echo "labuser:password123" | chpasswd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Entrypoint: start SSH + Wazuh agent
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
