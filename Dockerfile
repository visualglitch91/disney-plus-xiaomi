FROM alpine

WORKDIR /app

RUN apk update
RUN apk add libc6-compat openjdk8 curl

RUN curl -L -o /app/uber-apk-signer.jar https://github.com/patrickfav/uber-apk-signer/releases/download/v1.3.0/uber-apk-signer-1.3.0.jar
RUN curl -L -o /app/apktool https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
RUN curl -L -o /app/apktool.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.9.3.jar
RUN curl -L -o build-tools.zip https://dl.google.com/android/repository/build-tools_r33.0.2-linux.zip && unzip build-tools.zip && rm build-tools.zip

COPY entrypoint.sh /app/entrypoint.sh
RUN sh -c "chmod +x /app/entrypoint.sh"

CMD ["/app/entrypoint.sh"]
