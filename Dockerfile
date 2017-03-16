FROM ubuntu:14.04
MAINTAINER Ryo Sakaguchi <rsakaguchi3125@gmail.com>

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get update -y && apt-get -y install build-essential
RUN apt-get install -y git
RUN apt-get install -y unzip
RUN apt-get install -y libcurl3
RUN apt-get install -y libcurl3-gnutls
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y curl

# SSL
RUN dpkg --purge --force-depends ca-certificates-java
RUN apt-get install -y ca-certificates-java
RUN update-ca-certificates -f

RUN apt-get install -y software-properties-common curl && add-apt-repository -y ppa:openjdk-r/ppa && apt-get update && apt-get install -y openjdk-8-jdk

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ENV ANDROID_SDK_REVISION r25.2.4

RUN \
  cd /usr/local && \
  curl -L -O "https://dl.google.com/android/android-sdk_$ANDROID_SDK_REVISION-linux.tgz" && \
  tar -xf "android-sdk_$ANDROID_SDK_REVISION-linux.tgz" && \
  rm "/usr/local/android-sdk_$ANDROID_SDK_REVISION-linux.tgz"
RUN \
  cd /usr/local && \
  curl -L -O "https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip" && \
  tar -xf "android-ndk-r13b-linux-x86_64.zip" && \
  rm "/usr/local/android-ndk-r13b-linux-x86_64.zip"
RUN apt-get install -y lib32z1 lib32gcc1

ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDOIR_NDK_HOME /usr/local/android-ndk-r13b
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

RUN echo y | android update sdk --no-ui --force --all --filter "tools"
RUN echo y | android update sdk --no-ui --force --all --filter "platform-tools"
RUN echo y | android update sdk --no-ui --force --all --filter "build-tools-25.0.2, build-tools-23.0.3,build-tools-23.0.2,build-tools-23.0.1"
RUN echo y | android update sdk --no-ui --force --all --filter "android-24,android-24,android-23,android-22,android-21,android-19,android-17"
RUN echo y | android update sdk --no-ui --force --all --filter "extra-android-m2repository,extra-google-google_play_services,extra-google-m2repository"

# Install ruby dependencies
RUN add-apt-repository -y ppa:brightbox/ruby-ng && apt-get update && apt-get install -y ruby2.3
RUN apt-get install -y ruby2.3-dev

# Install fastlane
RUN gem install fastlane --verbose

# misc
RUN gem install curb

RUN apt-get clean 