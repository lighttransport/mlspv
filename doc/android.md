
## APK 

### Build

```
$ ./scripts/bootstrap-android-apk.sh
$ cd build-android-apk
$ ninja
```
### Run

```
$ adb install -r apk/build/apk/build/mlspv-debug.apk
```

```
$ adb shell am start -a android.intent.action.MAIN -c android-intent.category.LAUNCH -n com.lighttransport.mlspv/android.app.NativeActivity 
```
