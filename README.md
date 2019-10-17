# flutter_ok_sdk

SDK for odnoklassniki

This plugin is based on:
- Android: [odnoklassniki-android-sdk 2.1.8](https://github.com/odnoklassniki/ok-android-sdk)

## Installation

First, add  [*`flutter_vk_sdk`*](https://pub.dev/packages/flutter_kk_sdk#-installing-tab-)  as a dependency in [your pubspec.yaml file](https://flutter.io/platform-plugins/).

```
flutter_ok_sdk: ^0.0.1
```

### Android

In your android res/values create strings.xml and fill with this examples
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="ok_sdk_app_id" translatable="false">YOUR_APP_ID</string>
    <string name="ok_sdk_app_key" translatable="false">YOUR_APP_SECRET</string>
    <string name="ok_redirect_url" translatable="false">okYOUR_APP_ID://authorize</string>
</resources>
```

In your AndroidManifest.xml add an activity
```xml
        <activity
                android:name="ru.ok.android.sdk.OkAuthActivity"
                android:theme="@style/LaunchTheme">
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />

                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />

                <data
                        android:host="ok{YOUR_APP_ID}"
                        android:scheme="okauth" />
            </intent-filter>
        </activity>
```

### iOS

In info.plist add values

```xml
<key>OkAppId</key>
<string>YOUR_APP_ID</string>

<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>okYOUR_APP_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>okYOUR_APP_ID</string>
        </array>
    </dict>
</array>
```

In your AppDelegate add or append implementation for open url
```
import flutter_ok_sdk

override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    OKLogin.processOpen(url)
    return true
}
```