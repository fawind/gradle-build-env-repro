#!/bin/sh

java --version

export GRADLE_OPTS="-Dorg.gradle.jvmargs='-Xmx1g'"
./gradlew spotlessJava --rerun-tasks