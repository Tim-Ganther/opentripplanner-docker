FROM debian:sid

MAINTAINER Christian Kuntzsch <christian@kuntzsch.me>

RUN \
    apt-get update && \
    apt-get install -y openjdk-8-jre wget

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN \
    mkdir -p /var/otp && \
    wget -O /var/otp/otp.jar https://repo1.maven.org/maven2/org/opentripplanner/otp/1.2.0/otp-1.2.0-shaded.jar && \
    wget -O /var/otp/jython.jar http://search.maven.org/remotecontent?filepath=org/python/jython-standalone/2.7.0/jython-standalone-2.7.0.jar

ENV OTP_BASE /var/otp
ENV OTP_GRAPHS /var/otp/graphs

RUN \
    mkdir -p /var/otp/scripting && \
    mkdir -p /var/otp/graphs/brandenburg && \
    wget -O /var/otp/graphs/brandenburg/brb-gtfs.zip http://images.vbb.de/assets/ftp/file/1378234.zip && \
    wget -P /var/otp/graphs/brandenburg http://download.geofabrik.de/europe/germany/brandenburg-latest.osm.pbf && \
    java -Xmx8G -jar /var/otp/otp.jar --build /var/otp/graphs/brandenburg

EXPOSE 8080
EXPOSE 8081

ENTRYPOINT [ "java", "-Xmx6G", "-Xverify:none", "-cp", "/var/otp/otp.jar:/var/otp/jython.jar", "org.opentripplanner.standalone.OTPMain" ]

CMD [ "--help" ]
