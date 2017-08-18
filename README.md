# android-avd-docker
Docker image for Android running build tools for Marshmallow(23) with Lollipop arm emulator

Personal repo, use at your own risk. 

Contains :-
* Android SDK: r24.4.1
* Build tools: 23.0.2, 23.0.3
* Android API: 23
* Support maven repository
* Google maven repository
* Arm emulator: v22
* Platform tools
* Created emulator image named: "emu-lollipop"

## Build
`docker build -t rohithtr84/android-avd . `

## Run tests 

Change to project directory and run below command
`docker run --rm -it --volume=$(pwd):/opt/workspace --workdir=/opt/workspace --rm rohithtr84/android-avd /bin/sh -c "./test.sh"`

# test.sh
`#!/usr/bin/env bash`

`set -e`
`export TERM=dumb # needed for Gradle: https://issues.gradle.org/browse/GRADLE-2634`

`SHELL=/bin/bash emulator -avd emu-lollipop -no-skin -no-audio -no-window & /opt/tools/android-wait-for-emulator.sh`
`adb shell input keyevent 82`
`./gradlew connectedDevelopDebugAndroidTest`


