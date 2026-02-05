FROM alpine:3.19
WORKDIR /app

COPY cfnat-linux-arm64 /app/cfnat
COPY go.sh /app/go.sh
COPY ips-v4.txt /app/ips-v4.txt
COPY ips-v6.txt /app/ips-v6.txt
COPY locations.json /app/locations.json

RUN chmod +x /app/cfnat /app/go.sh
EXPOSE 1234

ENV colo="SJC,LAX,HKG" \
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

CMD ["/bin/sh", "/app/go.sh"]
