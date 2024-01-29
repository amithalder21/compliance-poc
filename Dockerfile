# Dockerfile for Prowler

FROM amazonlinux:2

MAINTAINER Amit Halder

# Install required packages
RUN yum -y update && \
    yum -y install yum install gcc openssl-devel bzip2-devel libffi-devel unzip git wget tar make && \
    cd /opt && \
    wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz && \
    tar xzf Python-3.9.16.tgz && \
    cd Python-3.9.16  && \
    ./configure --enable-optimizations && \
    make altinstall && \
    rm -f /opt/Python-3.9.16.tgz  && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip ./aws && \
    yum clean all

# Install Python 3.9
#RUN amazon-linux-extras enable python3.9 && \
#        yum install python3.9

# Create a symbolic link for python3.9
RUN ln -s /usr/bin/python3.9 /usr/bin/python3

# Clone Prowler repository
RUN git clone https://github.com/toniblyx/prowler.git

WORKDIR /prowler/

# Copy credentials and config file
COPY credentials /root/.aws/credentials

# Set Python version to 3.9
#RUN sed -i 's/python/python3.9/g' prowler

# Run Prowler
CMD ["./prowler", "-c", "prowler.config", "-b", "--json", "1"]
