FROM openjdk:8-jre-alpine

MAINTAINER Tim Ganther <tim.ganther@telekom.de>

ENV OTP_BASE /var/otp
ENV OTP_GRAPHS $OTP_BASE/graphs

COPY router-config.json $OTP_GRAPHS/ngermany/router-config.json

RUN set -x && \
    apk add --no-cache ca-certificates openssl && \
    mkdir -p $OTP_BASE/scripting $OTP_GRAPHS/ngermany && \
    wget -O $OTP_BASE/otp.jar https://repo1.maven.org/maven2/org/opentripplanner/otp/1.2.0/otp-1.2.0-shaded.jar && \
    wget -O $OTP_BASE/jython.jar http://search.maven.org/remotecontent?filepath=org/python/jython-standalone/2.7.0/jython-standalone-2.7.0.jar && \
    wget -O $OTP_GRAPHS/ngermany/hvv-gtfs.zip https://transitfeeds.com/p/hamburger-verkehrsverbund-gmbh/1010/latest/download && \
    wget -O $OTP_GRAPHS/ngermany/vbb-gtfs.zip https://transitfeeds.com/p/verkehrsverbund-berlin-brandenburg/213/20200331/download && \
    wget -O $OTP_GRAPHS/ngermany/db-gtfs.zip https://gtfs.de/de/feeds/de_fv/ && \
    wget -O $OTP_GRAPHS/ngermany/flixbus-gtfs.zip https://transitfeeds.com/p/flixbus/795/latest/download && \
    wget -P $OTP_GRAPHS/ngermany https://download.geofabrik.de/europe/germany/brandenburg-latest.osm.pbf && \
    wget -P $OTP_GRAPHS/ngermany https://download.geofabrik.de/europe/germany/hamburg-latest.osm.pbf && \
    wget -P $OTP_GRAPHS/ngermany https://download.geofabrik.de/europe/germany/sachsen-anhalt-latest.osm.pbf && \
    wget -P $OTP_GRAPHS/ngermany https://download.geofabrik.de/europe/germany/mecklenburg-vorpommern-latest.osm.pbf && \
    wget -P $OTP_GRAPHS/ngermany https://download.geofabrik.de/europe/germany/niedersachsen-latest.osm.pbf && \
    java -Xmx20G -jar /var/otp/otp.jar --build /var/otp/graphs/ngermany

EXPOSE 8080
EXPOSE 8081

ENTRYPOINT [ "java", "-Xmx20G", "-Xverify:none", "-cp", "/var/otp/otp.jar:/var/otp/jython.jar", "org.opentripplanner.standalone.OTPMain" ]

CMD [ "--help" ]
