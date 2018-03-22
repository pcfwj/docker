FROM ubuntu:14.04

MAINTAINER pcfwj <pcfwj@qq.com>


RUN mkdir -pv /usr/local/src
ADD sources.list /etc/apt/
ADD nginx-1.13.8.tar.gz  pcre2-10.30.tar.gz  /usr/local/src/

RUN apt-get update  && \
    apt-get -y install wget gcc  make openssl libssl-dev libpcre3 libpcre3-dev
RUN useradd -s /sbin/nologin -M www 


#WORKDIR
WORKDIR /usr/local/src/nginx-1.13.8 
RUN ./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_stub_status_module \
--with-pcre && make && make install

# run nginx in the foreground
RUN echo "daemon off;">>/usr/local/nginx/conf/nginx.conf 

# delete apt cache
RUN rm -rf /var/cache/apt/*

#ENV定义环境变量
ENV test_arg="hello world"
ENV PATH /usr/local/nginx/sbin:$PATH 
#EXPOSE 映射端口
EXPOSE 80 

CMD ["nginx"]



#ENTRYPOINT /usr/sbin/nginx
