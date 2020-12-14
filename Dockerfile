FROM openjdk:8-jre-alpine

MAINTAINER Tim Ganther <tim.ganther@telekom.de>

ENV OTP_BASE /var/otp
ENV OTP_GRAPHS $OTP_BASE/graphs

RUN set -x && \
    apk add --no-cache ca-certificates openssl && \
    mkdir -p $OTP_BASE/scripting $OTP_GRAPHS/ngermany && \
    wget -O $OTP_BASE/otp.jar https://repo1.maven.org/maven2/org/opentripplanner/otp/1.2.0/otp-1.2.0-shaded.jar && \
    wget -O $OTP_BASE/jython.jar http://search.maven.org/remotecontent?filepath=org/python/jython-standalone/2.7.0/jython-standalone-2.7.0.jar && \
    wget -O $OTP_GRAPHS/ngermany/hvv-gtfs.zip http://daten.transparenz.hamburg.de/Dataport.HmbTG.ZS.Webservice.GetRessource100/GetRessource100.svc/6245d691-d86a-4059-85a0-a997e7857092/Upload__HVV_Rohdaten_GTFS_UebgFpl_20201204.zip && \
    wget -O $OTP_GRAPHS/ngermany/vbb-gtfs.zip https://transitfeeds.com/p/verkehrsverbund-berlin-brandenburg/213/latest/download && \
    wget -O $OTP_GRAPHS/ngermany/db-gtfs.zip https://download.gtfs.de/germany/fv_free/latest.zip && \
    wget -O $OTP_GRAPHS/ngermany/rv-gtfs.zip https://download.gtfs.de/germany/rv_free/latest.zip && \
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
