FROM golang:1.24-alpine AS builder
ENV GOTOOLCHAIN=auto

WORKDIR /build

RUN apk update && apk add --no-cache git gcc musl-dev libc-dev curl bash tzdata nodejs npm

# دریافت آخرین سورس پنل سنایی
RUN git clone https://github.com/mhsanaei/3x-ui.git .

# بیلد کردن بخش فرانت‌اند و بک‌اند پنل
RUN go mod download
RUN go build -o x-ui main.go

FROM alpine:latest

WORKDIR /app

RUN apk add --no-cache bash tzdata curl python3

# کپی کردن خروجی بیلد شده از مرحله قبل
COPY --from=builder /build/x-ui /app/x-ui
COPY --from=builder /build/bin /app/bin
COPY --from=builder /build/web /app/web

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 2053

ENTRYPOINT ["/app/entrypoint.sh"]
