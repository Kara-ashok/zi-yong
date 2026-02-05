#!/bin/sh
set -eu

# 固定路径（与 Dockerfile 的 WORKDIR /app 对齐）
CFNAT_BINARY="/app/cfnat"
LOG="/app/cfnat.log"

# 读取环境变量并提供默认值（即使你没传 -e 也能跑）
colo="${colo:-SJC,LAX,HKG,SIN}"
delay="${delay:-300}"
ipnum="${ipnum:-20}"
ips="${ips:-4}"
num="${num:-5}"
port="${port:-443}"
random="${random:-true}"
task="${task:-100}"
tls="${tls:-true}"
code="${code:-200}"
domain="${domain:-cloudflaremirrors.com/debian}"

# 标准化 colo 为大写（避免大小写导致匹配失败）
colo_upper="$(echo "$colo" | tr '[:lower:]' '[:upper:]')"

# 记录启动信息（只写一次）
{
  echo "========================================"
  echo "启动时间: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "系统架构: $(uname -m)"
  echo "使用二进制文件: $CFNAT_BINARY"
  echo "数据中心(colo): $colo_upper"
  echo "有效延迟(delay): $delay"
  echo "IP类型(ips): $ips"
  echo "转发端口(port): $port"
  echo "TLS(tls): $tls"
  echo "随机IP(random): $random"
  echo "有效IP数(ipnum): $ipnum"
  echo "负载IP数(num): $num"
  echo "最大并发(task): $task"
  echo "状态码(code): $code"
  echo "检查域名(domain): $domain"
  echo "========================================"
} >> "$LOG"

# 关键检查：二进制是否存在且可执行（提前报错更好排查）
if [ ! -x "$CFNAT_BINARY" ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: 找不到或不可执行: $CFNAT_BINARY" >> "$LOG"
  exit 1
fi

# 循环守护：崩溃就重启
while true; do
  echo "$(date '+%Y-%m-%d %H:%M:%S') - cfnat 启动 ..." >> "$LOG"

  "$CFNAT_BINARY"     -addr="0.0.0.0:1234"     -colo="$colo_upper"     -delay="$delay"     -ips="$ips"     -port="$port"     -tls="$tls"     -random="$random"     -ipnum="$ipnum"     -num="$num"     -task="$task"     -code="$code"     -domain="$domain"     >> "$LOG" 2>&1   || echo "$(date '+%Y-%m-%d %H:%M:%S') - cfnat 异常退出，5 秒后重启..." >> "$LOG"

  sleep 5
done
