# 1) 选择基础镜像：Alpine 3.23.3（当前稳定版）
FROM alpine:3.23.3

# 2) 设置容器内工作目录（后续 COPY/RUN 相对路径都以这里为基准）
WORKDIR /app

# 3) 把程序和数据文件复制进镜像
#    注意：COPY 只能从 build context（仓库/构建目录）里复制文件 [10](https://docs.docker.com/build/concepts/context/)
COPY cfnat-linux-arm64 /app/cfnat
COPY go.sh /app/go.sh
COPY ips-v4.txt /app/ips-v4.txt
COPY ips-v6.txt /app/ips-v6.txt
COPY locations.json /app/locations.json

# 4) 赋予可执行权限
RUN chmod +x /app/cfnat /app/go.sh

# 5) 声明容器对外服务端口（文档/可读性；是否真正开放取决于 docker run -p）
EXPOSE 1234

# 6) 设置默认环境变量（容器运行时可被 -e 覆盖）[4](https://docs.docker.com/build/building/variables/)[8](https://labex.io/questions/what-does-the-env-instruction-do-in-a-dockerfile-884648)
ENV colo="SJC,LAX,HKG,SIN" \
    delay="300" \
    ipnum="10" \
    ips="4" \
    num="10" \
    port="443" \
    random="true" \
    task="100" \
    tls="true" \
    code="200" \
    domain="cloudflaremirrors.com/debian"

# 7) 容器启动时运行 go.sh（go.sh 内部会启动 cfnat 并循环守护）
CMD ["/bin/sh", "/app/go.sh"]
