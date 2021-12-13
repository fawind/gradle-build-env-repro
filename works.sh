#!/bin/sh

java --version

./gradlew spotlessJava --rerun-tasks
