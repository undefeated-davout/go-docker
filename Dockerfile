FROM centos:7

ARG GO_VERSION='1.14.4'

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

# git install
# RUN yum remove -y git \
#  && yum install -y https://centos7.iuscommunity.org/ius-release.rpm \
#  && yum install -y \
#             libsecret \
#             pcre2 \
#  && yum install -y git --enablerepo=ius --disablerepo=base,epel,extras,updates \
#  && rm -rf /var/cache/yum/* \
#  && yum clean all

# Japanese Locale Setting
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

# alias
RUN echo "alias ll='ls -la -F'" >> ~/.bashrc

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
 && go get github.com/derekparker/delve/cmd/dlv \
 && go get github.com/kisielk/errcheck

# nginx install
COPY ./nginx/nginx.repo /etc/yum.repos.d/nginx.repo
RUN yum install -y nginx
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
RUN systemctl enable nginx

RUN mkdir /var/log/code

# work directory
WORKDIR /opt/go_lang/go/src

CMD ["/sbin/init"]
