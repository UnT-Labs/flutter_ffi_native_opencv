# Flutter Native OpenCV using FFI Plugin
- For: Android & IOS
- How to using:
+ Method 1: clone project and using as a plugin
+ Method 2: create a new plugin by your self and config by following the tutorial

# A. Get the plugin
- Method 1: clone the project

- Method 2: create a new plugin by your self by following tutorial.
  - By following the tutorials, you need cho replace:
    + Any "native_opencv" by your plugin name.
    + Any "com.untlabs" by your domain.
## 1. Create the plugin and run the example
- Change by your self:
  - Plugin name: native_opencv
  - Domain: com.labs
```
flutter create --platforms=android,ios --template=plugin native_opencv --org com.untlabs
```
- Run the plugin example for Android and IOS, after that the file .podspec need to created in ios folder
- Some time you need youtube "example/ios" by *XCode* to config and run example project
## 2. Download files
**2.1. Download config files**
- Download the project -> upzip -> copy the below files and folder to the new plugin root:
  - Folder: src
  - File: script_download_opencv.sh
  - File: script_update_ios.sh
  - File: "lib/native_opencv.dart" replace for "lib/native_opencv.dart" in your plugin file.

**2.2. Download opencv for android and ios by run script**
```
sh script_download_opencv.sh
```
- The script will download opencv for Android and IOS 
- You can change "opencv_version" in the script by the lastest in: [OpenCV Releases](https://github.com/opencv/opencv/releases)


## 3. Setup ffi and ffigen
**3.1. Install**
- Install [ffi](https://pub.dev/packages/ffi) and [ffigen](https://pub.dev/packages/ffigen) package
```
flutter pub add ffi
flutter pub add ffigen
```

**3.2. Config and run ffigen**
- Add the config in "pubspec.yaml" file
```
ffigen:
  name: GeneratedBindings
  description: Bindings to opencv.
  output: "lib/generated_bindings.dart"
  headers:
    entry-points:
      - "src/native_opencv.h"
```
- Run *ffigen* to create dart functions from "src/native_opencv.h" file, run in the plugin root:
```
dart run ffigen
```
- The generated functions will create in "lib/generated_bindings.dart" file

## 4. Setups Android and IOS
**4.1. Setups for Android**
Change build file from: the-plugin-root/android/build.gradle
- Change default config for build C++:
```
    defaultConfig {
        minSdk = 21
        // UnT Labs
        externalNativeBuild {
            cmake {
                cppFlags '-frtti -fexceptions -std=c++20'
                arguments "-DANDROID_STL=c++_shared"
            }
        }
    }
```
- Add the CMkaleLists.txt:
```
    // UnT Labs
    externalNativeBuild {
        cmake {
            path "../src/CMakeLists.txt"
        }
    }
```
- Final file like this:
```
group = "com.untlabs.native_opencv"
version = "1.0-SNAPSHOT"

buildscript {
    ext.kotlin_version = "1.7.10"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:7.3.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

apply plugin: "com.android.library"
apply plugin: "kotlin-android"

android {
    if (project.android.hasProperty("namespace")) {
        namespace = "com.untlabs.native_opencv"
    }

    compileSdk = 34

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8
    }

    sourceSets {
        main.java.srcDirs += "src/main/kotlin"
        test.java.srcDirs += "src/test/kotlin"
    }

    defaultConfig {
        minSdk = 21
        // UnT Labs
        externalNativeBuild {
            cmake {
                cppFlags '-frtti -fexceptions -std=c++2a'
                arguments "-DANDROID_STL=c++_shared"
            }
        }
    }
    // UnT Labs
    externalNativeBuild {
        cmake {
            path "../src/CMakeLists.txt"
        }
    }

    dependencies {
        testImplementation("org.jetbrains.kotlin:kotlin-test")
        testImplementation("org.mockito:mockito-core:5.0.0")
    }

    testOptions {
        unitTests.all {
            useJUnitPlatform()

            testLogging {
               events "passed", "skipped", "failed", "standardOut", "standardError"
               outputs.upToDateWhen {false}
               showStandardStreams = true
            }
        }
    }
}
```

**4.2. Setups for IOS**

*a. Create modulemap file*
- In "ios" folder, create the file "ios/native_opencv.modulemap", edit with content:
```
{}
``` 
*b. Edit .podspec file*
- In "ios" folder, add the following config in the file:
```
  # telling CocoaPods not to remove framework
  s.preserve_paths = 'opencv2.framework' 

  # telling linker to include opencv2 framework
  s.xcconfig = { 
    'OTHER_LDFLAGS' => '-framework opencv2',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
  }

  # including OpenCV framework
  s.vendored_frameworks = 'opencv2.framework' 

  # including native framework
  s.frameworks = 'AVFoundation'

  # including C++ library
  s.library = 'c++'

  # module_map is needed so this module can be used as a framework
  s.module_map = 'native_opencv.modulemap'
```
- After that the .podspec file like the following:
```
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint native_opencv.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'native_opencv'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'native_opencv_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
  
  # Added by UnT
  # telling CocoaPods not to remove framework
  s.preserve_paths = 'opencv2.framework' 

  # telling linker to include opencv2 framework
  s.xcconfig = { 
    'OTHER_LDFLAGS' => '-framework opencv2',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
  }

  # including OpenCV framework
  s.vendored_frameworks = 'opencv2.framework' 

  # including native framework
  s.frameworks = 'AVFoundation'

  # including C++ library
  s.library = 'c++'

  # module_map is needed so this module can be used as a framework
  s.module_map = 'native_opencv.modulemap'
end
```

*c. Run the script to copy opencv cpp files*

- Run script_update_ios.sh to copy opencv cpp file from "src" folder to 'ios/Classes" folder
```
sh script_update_ios.sh
```

# B. Update OpenCV functions
1. Change you cpp code with opencv functions in "src/native_opencv.h" and "src/native_opencv.cpp" files.
2. Android will using the file directly, in IOS you need update/copy the files to "ios/Classes" folder by run "script_update_iod.sh" in the root plugin
```
sh script_update_iod.sh
```
3. Run *ffigen* again to update the functions name for function signatures
```
dart run ffigen
```
4. Using the generated functions in "lib/generated_bindings.dart" file
5. Create a example using the functions in examples project
# C. Using the plugin in example or new project
- In the project want to use the native_opencv plugin, add the plugin in dependencies of "pubspec.yaml" file
  - Replace "path: ./../native_opencv" by your path if different

```
dependencies:
  flutter:
    sdk: flutter
  native_opencv:
    path: ./../native_opencv
```
- Add cpp file in the plugin folder '/ios/Classes/src' to project:

```
Right click ios folder -> Open in Xcode -> Runner -> Build Phases -> Compile Sources -> + -> Select the files ( with copy option)
```