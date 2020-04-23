# @react-native-hero/splash-screen

## Getting started

Install the library using either Yarn:

```
yarn add @react-native-hero/splash-screen
```

or npm:

```
npm install --save @react-native-hero/splash-screen
```

## Link

- React Native v0.60+

For iOS, use `cocoapods` to link the package.

run the following command:

```
$ cd ios && pod install
```

For android, the package will be linked automatically on build.

- React Native <= 0.59

run the following command to link the package:

```
$ react-native link @react-native-hero/splash-screen
```

## Setup

Make sure you understand the native layout, this module does not support image as a splash screen.

* iOS: LaunchScreen.xib
* Android: android/app/src/main/res/layout/splash_screen_default.xml

### iOS

`AppDelegate.m`

```objective-c
#import <RNTSplashScreen.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  ...
  [RNTSplashScreen show];
  return YES;
}
```

### Android

`MainActivity.kt`

```kotlin
import com.github.reactnativehero.splashscreen.RNTSplashScreenModule

class MainActivity : ReactActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        RNTSplashScreenModule.show(this)
    }
}
```

## Example

```js
import {
  hide,
} from '@react-native-hero/splash-screen'

// Call hide method after your data or view is ready.
hide()
```
