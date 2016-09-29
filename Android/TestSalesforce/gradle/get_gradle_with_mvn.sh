#!/usr/bin/env bash

# === Pre-conditions ===
# === settings.xml configured with Proxy settings ===

export MAVEN_REPO=$HOME/.m2/repository_android_studio_manulife/

# === Get the android plugin for gradle ===
mvn dependency:get -DrepoUrl=https://repo1.maven.org/maven2/ -Dmaven.repo.local=$MAVEN_REPO -Dartifact=com.android.tools.build:gradle:2.1.3

# === Pre-conditions ===
# === https://repo1.maven.org/maven2/com/android/tools/build/gradle/2.1.3/gradle-2.1.3.pom ===
if [ -f "gradle-2.1.3.pom" ]; then
    # === Get all the dependencies of android plugin for gradle ===
    mvn org.apache.maven.plugins:maven-dependency-plugin:2.1:copy-dependencies -Dmaven.repo.local=$MAVEN_REPO -f gradle-2.1.3.pom

    # === Install all the dependencies inside the target folder ===
    mvn install dependency:copy-dependencies -f gradle-2.1.3.pom

    # === remove the target folder in current path ===
    rm -rf target

    # === install other 3rd party dependencies
    mvn dependency:get -DrepoUrl=https://repo1.maven.org/maven2/ -Dmaven.repo.local=$MAVEN_REPO -Dartifact=com.google.guava:guava:18.0
    mvn dependency:get -DrepoUrl=https://repo1.maven.org/maven2/ -Dmaven.repo.local=$MAVEN_REPO -Dartifact=com.squareup.okhttp3:okhttp:3.2.0
    mvn dependency:get -DrepoUrl=https://repo1.maven.org/maven2/ -Dmaven.repo.local=$MAVEN_REPO -Dartifact=com.squareup.okhttp3:okhttp:3.2.0
    mvn dependency:get -DrepoUrl=https://repo1.maven.org/maven2/ -Dmaven.repo.local=$MAVEN_REPO -Dartifact=net.zetetic:android-database-sqlcipher:3.5.2 -Dpackaging=aar
    mvn dependency:get -DrepoUrl=https://repo1.maven.org/maven2/ -Dmaven.repo.local=$MAVEN_REPO -Dartifact=org.jacoco:org.jacoco.agent:0.7.6.201602180812
    mvn dependency:get -DrepoUrl=https://repo1.maven.org/maven2/ -Dmaven.repo.local=$MAVEN_REPO -Dartifact=com.squareup.okio:okio:1.9.0

else
    echo "Please first download http://repo1.maven.org/maven2/com/android/tools/build/gradle/2.1.3/gradle-2.1.3.pom!"
fi