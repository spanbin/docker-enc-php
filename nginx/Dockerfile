# 定义Docker构建参数DOCKER_MIRROR_DOMAIN，用于指定DockerHub镜像域名
ARG DOCKER_MIRROR_DOMAIN

ARG NGINX_VERSION=nginx:1.26-alpine
FROM ${DOCKER_MIRROR_DOMAIN}${NGINX_VERSION}

# 拷贝相关配置
COPY . /etc/nginx

# 设置工作目录
WORKDIR /www

# 时区上海
ENV TZ=Asia/Shanghai