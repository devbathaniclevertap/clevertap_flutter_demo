plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Add this for Firebase
}

android {
    namespace = "com.clevertap.demo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.clevertap.demo"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
   // Firebase Messaging
    implementation("com.google.firebase:firebase-messaging:21.0.0")
    implementation(platform("com.google.firebase:firebase-bom:33.11.0"))
    implementation("com.google.firebase:firebase-analytics")

    // AndroidX Core and Fragment
    implementation("androidx.core:core:1.3.0")
    implementation("com.clevertap.android:clevertap-android-sdk:7.0.2")
    implementation("com.clevertap.android:push-templates:1.1.0")
    // MANDATORY for App Inbox
    implementation("androidx.appcompat:appcompat:1.3.1")
    implementation("androidx.recyclerview:recyclerview:1.2.1")
    implementation("androidx.viewpager:viewpager:1.0.0")
    implementation("com.google.android.material:material:1.10.0")
    implementation("com.github.bumptech.glide:glide:4.12.0")

    // CleverTap Install Referrer (Required for CleverTap SDK v3.6.4+)
    implementation("com.android.installreferrer:installreferrer:2.2")

    // Optional AndroidX Media3 Libraries for Audio/Video Inbox Messages
    implementation("androidx.media3:media3-exoplayer:1.1.1")
    implementation("androidx.media3:media3-exoplayer-hls:1.1.1")
    implementation("androidx.media3:media3-ui:1.1.1")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("androidx.fragment:fragment:1.3.6")
    implementation("androidx.core:core-ktx:1.12.0")
    implementation(project(":CT-Templates"))

    implementation ("com.clevertap.android:clevertap-geofence-sdk:1.4.0")
    implementation ("com.google.android.gms:play-services-location:21.0.0")
    implementation ("androidx.work:work-runtime:2.7.1") // required for FETCH_LAST_LOCATION_PERIODIC
    implementation ("androidx.concurrent:concurrent-futures:1.1.0") // required for FETCH_LAST_LOCATION_PERIODIC
}


flutter {
    source = "../.."
}
