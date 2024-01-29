# Dockerfile for Prowler

FROM amazonlinux:2

MAINTAINER Amit Halder

# Install required packages
RUN yum -y update && \
    yum -y install python3 unzip git && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip ./aws && \
    yum clean all

# Install Python 3.9
RUN amazon-linux-extras install python3.9

# Create a symbolic link for python3.9
RUN ln -s /usr/bin/python3.9 /usr/bin/python3

# Clone Prowler repository
RUN git clone https://github.com/toniblyx/prowler.git

WORKDIR /prowler/

# Copy credentials and config file
COPY credentials /root/.aws/credentials

# Set Python version to 3.9
RUN sed -i 's/python/python3.9/g' prowler

# Run Prowler
CMD ["./prowler", "-c", "prowler.config", "-b", "--json", "1"]
