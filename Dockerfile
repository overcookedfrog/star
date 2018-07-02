FROM alpine:3.7 as builder
RUN apk add --no-cache curl
RUN set -ex \
    && apk add --no-cache build-base curl zlib-dev bzip2-dev xz-dev curl-dev ncurses-dev openssl-dev \
    && curl -L -O https://github.com/alexdobin/STAR/archive/2.6.0c.tar.gz \
    && tar zxf 2.6.0c.tar.gz \
    && curl -L -O https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2 \
    && tar jxf samtools-1.7.tar.bz2 \
    && cd samtools-1.7 \
    && ./configure \
    && make

FROM alpine:3.7
RUN apk add --no-cache zlib libbz2 xz-libs ncurses libcurl openssl
COPY --from=builder /STAR-2.6.0c/bin/Linux_x86_64_static/STAR /usr/bin/STAR
COPY --from=builder /STAR-2.6.0c/bin/Linux_x86_64_static/STARlong /usr/bin/STARlong
COPY --from=builder /samtools-1.7/samtools /usr/bin/samtools

