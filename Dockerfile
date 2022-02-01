FROM amazonlinux:2
COPY dynamodb-local /opt/dynamodb-local

# Determine which build platform so we know what binaries to install
ARG TARGETPLATFORM

# Fake credentials required to work with local endpoint
ENV AWS_ACCESS_KEY_ID=local
ENV AWS_SECRET_ACCESS_KEY=local

# Set default value for features
ENV DYNAMODB_ADMIN_ENABLED=true
ENV DYNAMODB_CREATE_TABLES=true
ENV DYNAMODB_TABLE_SCHEMA_PATH=./tableSchema.json

# Set environment variables for NodeJs install
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 16.13.2
ENV NVM_INSTALL_PATH $NVM_DIR/versions/node/v$NODE_VERSION

# Install required linux utilities
RUN yum update --assumeyes --quiet --errorlevel=0 && \
    yum upgrade --assumeyes --quiet --errorlevel=0 && \
    yum install --assumeyes --quiet --errorlevel=0 less unzip gzip tar jq && \
    amazon-linux-extras install java-openjdk11 -y

# Install NodeJS and npm
RUN mkdir $NVM_DIR
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
ENV NODE_PATH $NVM_INSTALL_PATH/lib/node_modules
ENV PATH $NVM_INSTALL_PATH/bin:$PATH

# Install AWS CLI
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "/tmp/awscliv2.zip"; else curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"; fi
RUN unzip /tmp/awscliv2.zip -d /tmp/ && bash /tmp/aws/install

# Install dynamodb-admin GUI
RUN npm install -g dynamodb-admin

WORKDIR /opt/dynamodb-local

# Install dynamodb-local
RUN curl "https://s3.us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz" -o /opt/dynamodb-local/dynamodb_local_latest.tar.gz && \
    tar -xvzf dynamodb_local_latest.tar.gz

EXPOSE 8000 8001

CMD ./entrypoint.sh