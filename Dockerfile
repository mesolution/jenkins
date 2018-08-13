FROM jenkins:2.19.2
MAINTAINER Li Yi <denverdino@gmail.com>
USER root
RUN GOSU_SHA=5ec5d23079e94aea5f7ed92ee8a1a34bbf64c2d4053dadf383992908a2f9dc8a && curl -sSL -o /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.9/gosu-$(dpkg --print-architecture)" \
	&& chmod +x /usr/local/bin/gosu && echo "$GOSU_SHA  /usr/local/bin/gosu" | sha256sum -c - 
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt