FROM centos:8

ARG GO_VERSION='1.16.3'

# yum install
RUN yum update -y \
    && yum groupinstall -y "Development tools" \
    && yum install -y \
    cmake \
    curl \
    gcc \
    make \
    sudo \
    tmux \
    unzip \
    vim \
    wget \
    git \
    && rm -rf /var/cache/yum/* \
    && yum clean all

# alias
RUN echo "alias ll='ls -lahF --color=auto'" >> ~/.bashrc

# go install
WORKDIR /opt/go_lang/
RUN wget https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar zxvf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm -f go${GO_VERSION}.linux-amd64.tar.gz
RUN mv go .go
RUN mkdir go
# ENV
ENV GOROOT /opt/go_lang/.go
ENV GOPATH /opt/go_lang/go
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH

# debug tools install
RUN go get github.com/labstack/echo \
    && go get github.com/labstack/echo/middleware \
    && go get github.com/go-delve/delve \
    && go get github.com/kisielk/errcheck

# nginx install
COPY ./nginx/nginx.repo /etc/yum.repos.d/nginx.repo
RUN yum install -y nginx
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
RUN systemctl enable nginx

RUN mkdir /var/log/code

# AWS CLI
RUN dnf install -y wget python3
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py
RUN pip install awscli
ENV PATH $PATH:/root/.local/bin

# work directory
WORKDIR /opt/go_lang/go/src

CMD ["/sbin/init"]
