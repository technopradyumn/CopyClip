import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
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
        versionCode = 20
        versionName = "1.3.3"
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            val keyAliasValue = keystoreProperties["keyAlias"] as String? ?: ""
            val keyPasswordValue = keystoreProperties["keyPassword"] as String? ?: ""
            val storeFileValue = keystoreProperties["storeFile"] as String? ?: ""
            val storePasswordValue = keystoreProperties["storePassword"] as String? ?: ""

            keyAlias = keyAliasValue
            keyPassword = keyPasswordValue
            if (storeFileValue.isNotEmpty()) {
                storeFile = file(storeFileValue)
            }
            storePassword = storePasswordValue
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            
            // ✅ OPTIMIZATION: Use ProGuard for aggressive optimization
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")

            manifestPlaceholders["ADMOB_APP_ID"] =
                localProperties.getProperty("ADMOB_APP_ID")
        }

        debug {
            signingConfig = signingConfigs.getByName("debug")
            manifestPlaceholders["ADMOB_APP_ID"] = "ca-app-pub-3940256099942544~3347511713"
        }
    }

    // ✅ OPTIMIZATION: Generate split APKs for different architectures
    // This reduces APK size by 30-40% for end users
//    splits {
//        abi {
//            isEnable = true
//            reset()
//            include("armeabi-v7a", "arm64-v8a", "x86_64")
//            isUniversalApk = false
//        }
//    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.1.0"))
    implementation("com.google.firebase:firebase-analytics")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}