FROM debian:9-slim

# Install dependencies
RUN set -xe \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
       sudo curl ca-certificates desktop-file-utils shared-mime-info \
       libxrandr2 libasound2 libgstreamer1.0-0 libgstreamer-plugins-base1.0-0 \
       lib32z1 libx11-6 libegl1-mesa libxcb-shm0 libglib2.0-0 \
       libgl1-mesa-glx libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa \
       libxrender1 libxcomposite1 libxslt1.1 \
       libxi6 libsm6 libfontconfig1 libpulse0 libsqlite3-0 \
       libxcb-shape0 libxcb-xfixes0 libxcb-randr0 libxcb-image0 \
       libxcb-keysyms1 libxcb-xtest0 ibus ibus-gtk libibus-qt1 ibus-qt4 \
       libnss3 libxss1 \
    && rm -rf /var/lib/apt/lists/*

# Install Zoom
ARG zoom_url=https://zoom.us/client/latest/zoom_amd64.deb

RUN set -xe \
    && curl -fsSL "${zoom_url}" -o /tmp/zoom.deb \
    && dpkg --install /tmp/zoom.deb \
    || ( \
        apt-get update -qq \
        && apt-get -y -qq --fix-broken install \
        && rm -rf /var/lib/apt/lists/* \
    ) \
    && rm /tmp/zoom.deb

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["zoom"]
