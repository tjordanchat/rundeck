FROM canopytax/java8:latest
MAINTAINER Skyler Lewis <skyler.lewis@canopytax.com>

# In case someone loses the Dockerfile
RUN rm -rf /etc/Dockerfile
ADD Dockerfile /etc/Dockerfile

# Gradle
WORKDIR /usr/bin
RUN add-apt-repository -y ppa:cwchien/gradle && \
    apt-get update && \
    apt-get install -yf git gradle-2.4 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ && \
    gradle --version && \
    touch $HOME/.gradle/gradle.properties && echo "org.gradle.daemon=true" >> $HOME/.gradle/gradle.properties


# Set Appropriate Environmental Variables
ENV GRADLE_HOME /usr/bin/gradle
ENV PATH $PATH:$GRADLE_HOME/bin

# Default command is "/usr/bin/gradle -version" on /app dir
# (ie. Mount project at /app "docker --rm -v /path/to/app:/app gradle <command>")
RUN mkdir /app
WORKDIR /app
ENTRYPOINT ["gradle"]
CMD ["-b /app/all/build.gradle clean uploadArchives shadowjar"]
