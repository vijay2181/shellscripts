#bin/bash

#This script will get latest 10 artifacts from nexus

NEXUS_URL=http://<ip-address>:8081
MAVEN_REPO=maven-nexus-repo
GROUP_ID=net.java
ARTIFACT_ID=cargo-tracker
VERSION=1.0-SNAPSHOT
FILE_EXTENSION=war

download_url=$(curl -s --user jenkins-user:jenkins-user -X GET "${NEXUS_URL}/service/rest/v1/search/assets?repository=${MAVEN_REPO}&maven.groupId=${GROUP_ID}&maven.artifactId=${ARTIFACT_ID}&maven.baseVersion=${VERSION}&maven.extension=${FILE_EXTENSION}" -H  "accept: application/json"  | jq -rc '.items | .[].downloadUrl' | sort | tail -n 10)
echo $download_url 
