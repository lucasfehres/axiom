FROM docker.io/azul/zulu-openjdk-debian:27-latest

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:100 \
    XPRA_PORT=14500 \
    XPRA_PASSWORD="" \
    XPRA_ENCODING=h264 \
    XPRA_DPI=96 \
    XPRA_RESIZE=yes

RUN apt update \
    && apt install --yes ca-certificates curl gnupg \
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null \
    && echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main' \
    | tee /etc/apt/sources.list.d/microsoft-edge-stable.list \
    && apt update \
    && apt install --yes \
    xvfb \
    xpra \
    openbox \
    xauth \
    xdg-utils \
    dbus-x11 \
    curl \
    wget \
    unzip \
    bash \
    ca-certificates \
    davmail \
    microsoft-edge-stable \
    menu \
    xterm \
    gosu \
    libswt-gtk-4-java \
    libswt-webkit-gtk-4-jni \
    && apt-get clean \
    && rm -rf /var/cache/apt/lists

COPY davmail_7.0.0-4403-1_all.deb /davmail_7.0.0-4403-1_all.deb
RUN dpkg -r davmail davmail-server && dpkg -i /davmail_7.0.0-4403-1_all.deb

# Create non-root user
RUN useradd -m -s /bin/bash xprauser

# Xpra's default config also starts "/etc/X11/Xsession true", which pops up an
# xmessage error; openbox-session is started explicitly by entrypoint.sh instead
RUN sed -i 's|^start = /etc/X11/Xsession true|#&|' /etc/xpra/conf.d/60_server.conf

# Openbox autostart: global (not in ~) since the home dir is a persistent volume
COPY openbox.sh /etc/xdg/openbox/autostart

COPY davmail.properties /etc/davmail.properties
COPY config.sh /config.sh
RUN chmod +x /config.sh

COPY edge.sh /edge.sh
RUN chmod +x /edge.sh

COPY edge.desktop /usr/share/applications/fake-microsoft-edge.desktop

COPY priv-entrypoint.sh /priv-entrypoint.sh
RUN chmod +x /priv-entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE ${XPRA_PORT}

WORKDIR /home/xprauser

ENTRYPOINT ["/priv-entrypoint.sh"]
