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
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.technopradyumn.copyclip"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
    }

    signingConfigs {
        println("🔐 Loaded keystore properties:")
        println("  keyAlias = ${keystoreProperties["keyAlias"]}")
        println("  keyPassword = ${keystoreProperties["keyPassword"]}")
        println("  storeFile = ${keystoreProperties["storeFile"]}")
        println("  storePassword = ${keystoreProperties["storePassword"]}")
        create("release") {
            val keyAliasValue = keystoreProperties["keyAlias"] as? String
            val keyPasswordValue = keystoreProperties["keyPassword"] as? String
            val storeFileValue = keystoreProperties["storeFile"] as? String
            val storePasswordValue = keystoreProperties["storePassword"] as? String

            if (
                keyAliasValue != null &&
                keyPasswordValue != null &&
                storeFileValue != null &&
                storePasswordValue != null
            ) {
                keyAlias = keyAliasValue
                keyPassword = keyPasswordValue
                storeFile = file(storeFileValue)
                storePassword = storePasswordValue
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
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