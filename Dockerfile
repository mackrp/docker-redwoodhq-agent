FROM ubuntu

ENV VNC_PASSWORD admin
ENV VNC_PORT 5900

ENV AGENT_PORT 5009

ENV APP_SERVER_PORT 3000
ENV APP_SERVER_HOST 127.0.0.1

ADD http://redwoodhq.com/download/RedwoodHQAgentLinux_250.tar.gz ./
RUN tar xzvf RedwoodHQAgentLinux_250.tar.gz
RUN sed -i 's/AgentPort=([0-9]*)/AgentPort=$AGENT_PORT/' RedwoodHQAgent/properties.conf
RUN sed -i 's/AppServerPort=([0-9]*)/AppServerPort=$APP_SERVER_PORT/' RedwoodHQAgent/properties.conf
RUN sed -i 's/AppServerIPHost=(.*)/AppServerIPHost=$APP_SERVER_HOST/' RedwoodHQAgent/properties.conf

RUN apt-get update && apt-get install -y x11vnc xvfb firefox chromium-browser
RUN mkdir ~/.vnc

RUN x11vnc -storepasswd $VNC_PASSWORD ~/.vnc/passwd

RUN bash -c 'echo "cd RedwoodHQAgent/agent && ./start.sh" >> /.bashrc'

EXPOSE $VNC_PORT
EXPOSE $AGENT_PORT

CMD    ["x11vnc", "-forever", "-usepw", "-create"]