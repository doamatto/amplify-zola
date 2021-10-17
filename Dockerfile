FROM amazonlinux:2

ENV VERSION_ZOLA=0.14.1
ENV VERSION_NODE=14.17.6

# Install Curl, Git, OpenSSL (AWS Amplify requirements) and tar (required to unpack Zola)
RUN touch ~/.bashrc
RUN yum -y update && \
    yum -y install \
    curl \
    git \
    openssl \
    tar \
    yum clean all && \
    rm -rf /var/cache/yum
    
# Install Node (AWS Amplify requirement)
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN /bin/bash -c ". ~/.nvm/nvm.sh && \
    nvm install $VERSION_NODE && nvm use $VERSION_NODE && \
    nvm alias default node && nvm cache clear"
    
# Install Zola
RUN https://github.com/getzola/zola/releases/download/v${VERSION_ZOLA}/zola-v${VERSION_ZOLA}-x86_64-unknown-linux-gnu.tar.gz && \
    tar -xf zola-v${VERSION_ZOLA}-x86_64-unknown-linux-gnu.tar.gz / && \
    mv /zola /usr/bin/zola && \
    rm -rf zola-v${VERSION_ZOLA}-x86_64-unknown-linux-gnu.tar.gz
    
# Configure environment
RUN echo export PATH="\
    /root/.nvm/versions/node/${VERSION_NODE}/bin:\
    $PATH" >> ~/.bashrc && \
    echo "nvm use ${VERSION_NODE} 1> /dev/null" >> ~/.bashrc
    
ENTRYPOINT [ "bash", "-c" ]
