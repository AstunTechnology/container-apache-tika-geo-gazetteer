FROM maven:3-jdk-8 as build
WORKDIR /srv
RUN apt-get update && apt-get install -y git\
    && git clone --depth=1 https://github.com/AstunTechnology/lucene-geo-gazetteer.git
WORKDIR /srv/lucene-geo-gazetteer
RUN mvn install assembly:assembly
COPY gb.zip .
RUN apt-get update && apt-get install -y unzip && unzip gb.zip

# add in the mapped CSV
COPY test.csv srv/lucene-geo-gazetteer/test.csv

RUN /srv/lucene-geo-gazetteer -i geoIndex -b test.csv

FROM openjdk:8-jre-slim
WORKDIR /srv
COPY --from=build /srv/lucene-geo-gazetteer/target/lucene-geo-gazetteer-0.3-SNAPSHOT-jar-with-dependencies.jar lucene-geo-gazetteer-jar-with-dependencies.jar
COPY --from=build /srv/lucene-geo-gazetteer/geoIndex /srv/geoIndex
RUN mkdir -p resources/org/apache/tika/parser/geo/topic\
    && chmod ag+w resources/org/apache/tika/parser/geo/topic\
    && mkdir -p resources/org/apache/tika/mime\
    && mkdir bin
COPY en-ner-location.bin resources/org/apache/tika/parser/geo/topic
COPY custom-mimetypes.xml resources/org/apache/tika/mime
COPY lucene-geo-gazetteer bin
ENV PATH="${PATH}:/srv/bin"
COPY tika-server-standard-2.6.0.jar .
COPY tika_run_hack.sh .
ENTRYPOINT [ "./tika_run_hack.sh" ]
