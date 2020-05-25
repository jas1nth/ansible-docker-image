FROM ubuntu:focal

LABEL maintainer='JP Pakalapati'

# Install required system packages and dependencies
RUN apt-get -q update && \
    apt-get -y --no-install-recommends install software-properties-common locales \
    python3-pip python3-setuptools python3-wheel && \
    rm -Rf /var/lib/apt/lists/* && \
    rm -Rf /usr/share/doc && rm -Rf /usr/share/man && \
    apt-get clean

# Fix potential UTF-8 errors with ansible-test
RUN locale-gen en_US.UTF-8

# Install Ansible via pip
RUN pip3 install ansible

# Run ansible as non-root to avoid security risks
RUN groupadd ansible && useradd -g ansible ansible

# Install Ansible inventory file
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_user=ansible ansible_connection=local" > /etc/ansible/hosts

# Create ansible playbook directory for volume mount
WORKDIR /app

CMD ["bash"]
