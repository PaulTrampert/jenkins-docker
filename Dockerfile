FROM jenkins/jenkins:lts

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV CASC_JENKINS_CONFIG="/usr/share/jenkins/casc_configs/"
ENV DOCKER_SOCKET="/var/run/docker.sock"
ENV DOCKER_GROUP="dockerhost"
ENV JENKINS_USER="jenkins"

USER root

RUN apt-get update && \
  apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common python3-pip sudo gosu -y && \
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
  apt-get update && \
  apt-get install docker-ce-cli -y && \
  pip3 install docker-compose

RUN mkdir ${CASC_JENKINS_CONFIG} \
  && chown -R jenkins:jenkins ${CASC_JENKINS_CONFIG}

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
