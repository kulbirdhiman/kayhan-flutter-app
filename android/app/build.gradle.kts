plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.kayhan_app"

    // ✅ Update compileSdk to match latest requirements
    compileSdk = 35

    // ✅ Set explicit NDK version (instead of flutter.ndkVersion)
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.kayhan_app"
        minSdk = flutter.minSdkVersion
        targetSdk = 35 // ✅ safer to explicitly match compileSdk
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // ABI filters (optional – controls which CPU architectures you build for)
        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86_64")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
