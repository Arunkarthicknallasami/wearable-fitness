#!/bin/sh

clear && ./gradlew assembleDebug && adb install -r app/build/outputs/apk/app-debug.apk && adb shell monkey -p com.jeffrey.mobile.testfacebooklogin -c android.intent.category.LAUNCHER 1
