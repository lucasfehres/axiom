FROM azul/zulu-openjdk-debian:21-latest

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
    && apt-get clean \
    && rm -rf /var/cache/apt/lists

# Create non-root user
RUN useradd -m -s /bin/bash xprauser

# Openbox config: autostart nothing by default (apps can be added via env/volume)
RUN mkdir -p /home/xprauser/.config/openbox
COPY openbox.sh /home/xprauser/.config/openbox/autostart
RUN chown -R xprauser:xprauser /home/xprauser/.config

COPY davmail.properties /etc/davmail.properties
COPY config.sh /config.sh
RUN chmod +x /config.sh

COPY edge.sh /edge.sh
RUN chmod +x /edge.sh

COPY edge.desktop /home/xprauser/.local/share/applications/fake-microsoft-edge.desktop

COPY priv-entrypoint.sh /priv-entrypoint.sh
RUN chmod +x /priv-entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE ${XPRA_PORT}

WORKDIR /home/xprauser

ENTRYPOINT ["/priv-entrypoint.sh"]
