FROM jenkins/jenkins:lts

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV CASC_JENKINS_CONFIG="/usr/share/jenkins/casc_configs/"

USER root

RUN apt-get update && \
  apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common python3-pip sudo -y && \
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
  apt-get update && \
  apt-get install docker-ce-cli -y && \
  pip3 install docker-compose

RUN mkdir ${CASC_JENKINS_CONFIG} \
  && chown -R jenkins:jenkins ${CASC_JENKINS_CONFIG} \
  && echo "jenkins ALL=(ALL) NOPASSWD: /usr/bin/docker" >> /etc/sudoers \
  && echo "alias docker='sudo docker '" >> /etc/profile.d/00-aliases.sh \
  && chmod +x /etc/profile.d/00-aliases.sh
COPY docker /usr/local/sbin/docker

USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
