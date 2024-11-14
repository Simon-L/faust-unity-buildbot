FROM thyrlian/android-sdk:latest

WORKDIR /root

RUN \
  apt-get update && \
  apt-get install -y build-essential file g++-mingw-w64-x86-64-win32

RUN /opt/android-sdk/cmdline-tools/tools/bin/sdkmanager --update
RUN /opt/android-sdk/cmdline-tools/tools/bin/sdkmanager "ndk-bundle"

ADD https://nightly.link/Simon-L/faust/workflows/ubuntu/Simon-L-gh-actions/pfx.zip ./pfx.zip
RUN unzip ./pfx.zip -d /usr/local

RUN sed -i 's/armeabi-v7a/arm64-v8a/g' /usr/local/share/faust/unity/Android/Application.mk
RUN sed -i 's/armeabi-v7a/arm64-v8a/g' /usr/local/bin/faust2androidunity

RUN which faust

ENV ANDROID_HOME=/opt/android-sdk/

ENTRYPOINT ["faust2unity"]
CMD ["-android", "-linux", "-w64", "-unpacked", "main.dsp"]