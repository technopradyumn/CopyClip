import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.technopradyumn.copyclip"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.technopradyumn.copyclip"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = 13
        versionName = "1.2.1"
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            val keyAliasValue = keystoreProperties["keyAlias"] as String
            val keyPasswordValue = keystoreProperties["keyPassword"] as String
            val storeFileValue = keystoreProperties["storeFile"] as String
            val storePasswordValue = keystoreProperties["storePassword"] as String

            keyAlias = keyAliasValue
            keyPassword = keyPasswordValue
            storeFile = file(storeFileValue)
            storePassword = storePasswordValue
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true

            manifestPlaceholders["ADMOB_APP_ID"] =
                project.findProperty("ADMOB_APP_ID") as String? ?: ""

        }

        debug {
            signingConfig = signingConfigs.getByName("debug")
            manifestPlaceholders["ADMOB_APP_ID"] =
                "ca-app-pub-3940256099942544~1033173712"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.1.0"))
    implementation("com.google.firebase:firebase-analytics")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}