FROM adoptopenjdk/maven-openjdk11-openj9@sha256:a6ffa4b5ce96ce132d955999e80b3aad2f5c4a897c8d3ecffa12e2f3f9edb37d AS TEST-STEP
RUN mkdir -p /usr/test-build
RUN mkdir -p /home/testuser/.m2
RUN addgroup testgroup
RUN adduser testuser --ingroup testgroup
WORKDIR /usr/test-build
COPY . /usr/test-build
RUN chown -R testuser:testgroup /usr/test-build
RUN chown -R testuser:testgroup /home/testuser/.m2
USER testuser
RUN mvn dependency:resolve && mvn dependency:go-offline
RUN mvn clean test surefire-report:report

FROM adoptopenjdk/maven-openjdk11-openj9@sha256:a6ffa4b5ce96ce132d955999e80b3aad2f5c4a897c8d3ecffa12e2f3f9edb37d AS BUILD-STEP
RUN mkdir /usr/app
RUN mkdir -p /home/appbuilder/.m2
RUN addgroup appgroup
RUN adduser appbuilder --ingroup appgroup
COPY src /usr/app/src
COPY pom.xml /usr/app
WORKDIR /usr/app
COPY --from=TEST-STEP /home/testuser/.m2 /home/appbuilder/.m2
RUN chown -R appbuilder:appgroup /usr/app
RUN chown -R appbuilder:appgroup /home/appbuilder/.m2
USER appbuilder
RUN mvn clean package -DskipTests

FROM adoptopenjdk/openjdk11-openj9:alpine-jre@sha256:1eefc165e1ac671ec5b502c6b60fe9f311b8833006c560f70d2c9882cf844a5d AS APP
RUN apk add dumb-init
RUN mkdir -p /usr/app
RUN mkdir -p /usr/app/shareclasses
WORKDIR /usr/app
RUN addgroup appgroup
RUN adduser -D -H appuser --ingroup appgroup
COPY --from=BUILD-STEP /usr/app/target/redisExample.jar /usr/app/redisExample.jar
RUN chown -R appuser:appgroup /usr/app
USER appuser
CMD ["dumb-init", "java", "-Xmx128m", "-XX:+IdleTuningGcOnIdle", "-Xtune:virtualized", "-Xscmx128m", "-Xscmaxaot100m", "-Xshareclasses:cacheDir=/usr/app/shareclasses", "-jar", "/usr/app/redisExample.jar"]


