FROM ubuntu

ENV VNC_PASSWORD admin
ENV VNC_PORT 5900

ENV AGENT_PORT 5009

ENV APP_SERVER_PORT 3002
ENV APP_SERVER_HOST 192.168.100.158

WORKDIR /usr/local

ADD http://redwoodhq.com/download/RedwoodHQAgentLinux_250.tar.gz ./
RUN tar xzvf RedwoodHQAgentLinux_250.tar.gz

WORKDIR /usr/local/RedwoodHQAgent

RUN apt-get update && apt-get install -y x11vnc xvfb firefox chromium-browser fluxbox tofrodos

RUN fromdos /usr/local/RedwoodHQAgent/properties.conf

RUN mkdir ~/.vnc

RUN x11vnc -storepasswd $VNC_PASSWORD ~/.vnc/passwd

COPY ./xinitrc /root/.xinitrc
RUN chmod +x ~/.xinitrc

EXPOSE $VNC_PORT
EXPOSE $AGENT_PORT

CMD    ["x11vnc", "-forever", "-usepw", "-create"]
