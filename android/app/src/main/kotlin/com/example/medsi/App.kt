package com.example.medsi

import android.app.Application
//using https://medium.com/stuart-engineering/keep-flutter-running-background-on-android-6ffc85be0234 plugin
// code here https://github.com/ppicas/flutter-android-background

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        registerActivityLifecycleCallbacks(LifecycleDetector.activityLifecycleCallbacks)
    }
}