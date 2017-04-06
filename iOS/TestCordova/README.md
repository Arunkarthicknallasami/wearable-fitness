# Hybrid Support
Support for `Cordova-based` Android application project
<br/><br/>

## Development Tooling

### Cordova
* Nodejs : v6.10.1 / v7.6.0
* npm : 3.10.10 / 4.1.2
* Cordova CLI : 6.5.0

### Android
* Windows 7 Enterprise
* Android Studio : 2.3
* Android SDK : API Level 25
* Android SDK Build Tools : 25.0.2
* Android SDK Tools : 26.0.1
* Android SDK Platform Tools : 25.0.4
* Android Plugin for Gradle : 2.3.1
* Gradle : 3.3
* Cordova-Android : 6.1.2

### iOS
* OSX : Mac OS X 10.12.4 (16E195)
* Xcode : 8.3 (8E162)
* Cocoapods : 1.1.1
* Ruby: ruby 2.2.2p95 (2015-04-13 revision 50295) [x86_64-darwin14]
* RubyGems : 2.4.8
* Bundler : 1.13.6
* Cordova-ios  : 4.3.1

<br/>

#### IMPORTANT
In the latest Android SDK Tools (v25.3.1), the `android` command no longer operates as expected and instead exits with a non-zero status code with following error when invoking all cordova commands related with Android: i.e. *cordova requirements android*:
```
Cordova: Android SDK not found. Make sure that it is installed. If it is not at the default location, set the ANDROID_HOME environment variable
```
<br/>

The issue has been reported to Cordova, click [HERE](https://issues.apache.org/jira/browse/CB-12554) to read. The interim approach is import the Android project under ~\platforms\android into Android Studio, and use the gradle wrapper command *gradlew assembleDebug* to build the APK. You may also need to modify the `~\build.gradle` and `~\gradle\wrapper\gradle-wrapper.properties` to replace with the preferred version of Gradle and Android Plugin for Gradle.
<br/>

When running on OS X 10.11 El Capitan or greater version, installing ios-deploy may encounter error when install with command *sudo npm install -g ios-deploy*, click [HERE](https://www.npmjs.com/package/ios-deploy) to read. The workaround is to invoke the command with additional parameters:
```
sudo npm install -g ios-deploy --unsafe-perm=true --allow-root
```
<br/>

## Adding Cocoapods dependencies in Cordova-based iOS app

### Approach 1 - *use 3rd party cordova-plugin-cocoapod-support*
1. add the plugin:
   ```ruby
   cordova plugin add https://github.com/blakgeek/cordova-plugin-cocoapods-support.git
   ```
2. modify the config.xml to add the target Cocoapods dependencies in the ios platform section, for example ObjectMapper:
   ```xml
   <platform name="ios">
       <allow-intent href="itms:*" />
       <allow-intent href="itms-apps:*" />
       <!-- optionally set minimum ios version and enable use_frameworks! -->
       <pods-config ios-min-version="9.3" use-frameworks="true">
         <!-- optionally add private spec sources -->
         <source url="https://github.com/CocoaPods/Specs.git"/>
         <source url="https://github.com/forcedotcom/SalesforceMobileSDK-iOS-Specs.git"/>
       </pods-config>
       <!-- use a specific version of a pod -->
       <pod name="ObjectMapper" git="https://github.com/Hearst-DD/ObjectMapper.git" tag="2.2.5" />
   </platform>
   ```
3. generate the Podfile in platforms/ios
   ```ruby
   cordova prepare
   ```
4. modify the Podfile in platforms/ios and add the following lines the beginning of the file
   ```
   use_frameworks!
   platform :ios, '9.3'
   inhibit_all_warnings!
   ```
5. execute `pod install` command under platforms/ios to re-generate the Xcode project and workspace
6. now launch Xcode via the .xcworkspace file and rebuild the source

For details, read [HERE](https://github.com/blakgeek/cordova-plugin-cocoapods-support)
<br/><br/>

### Approach 2 - *direct integration with Cocoapods*
1. use cordova-ios version 4.3.0 or above:
   ```ruby
   cordova platform add ios@4.3.0
   ```
2. modify the config.xml to add the target Cocoapods dependencies as below:
   ```xml
   <framework src="ObjectMapper" type="podspec" spec="~> 2.2.5" />
   ```

For details, read [HERE](https://cordova.apache.org/announcements/2016/10/24/ios-release.html)
<br/><br/>

## Creating plugin in Swift 3.0
1. install plugman via npm
   ```ruby
   sudo npm install -g plugman
   ```

2. use Plugman to add Swift support to the `Cordova-based` iOS project
   ```ruby
   plugman install --platform ios --project platforms/ios/ --plugin cordova-plugin-add-swift-support
   ```

3. use Plugman to create an initial plugin from template under the ~/plugins directory
   ```ruby
   plugman create --name TestSwiftPlugin --plugin_id com-manulife-core-testswiftplugin --plugin_version 0.0.1 --path plugins
   ```

4. edit the plugin.xml under the ~/plugins/TestSwiftPlugin, configure the package name and the corresponding native plugin source file in the <plugin> element:
   ```xml
   <plugin id="com-manulife-core-testswiftplugin" version="0.0.1" xmlns="http://apache.org/cordova/ns/plugins/1.0" xmlns:android="http://schemas.android.com/apk/res/android">
       <name>TestSwiftPlugin</name>
       <js-module name="TestSwiftPlugin" src="www/TestSwiftPlugin.js">
           <clobbers target="cordova.plugins.TestSwiftPlugin" />
       </js-module>

       <platform name="ios">
           <config-file target="config.xml" parent="/*">
              <!-- The feature's name attribute should match what you specify as the JavaScript exec call's service parameter -->
              <feature name="TestSwiftPlugin">
                <!-- The value attribute should match the name of the plugin's Swift class -->
                <param name="ios-package" value="TestSwiftPlugin" />
              </feature>
          </config-file>
          <!-- The relative path of the Swift plugin source code -->
          <source-file src="src/ios/TestSwiftPlugin.swift" />
        </platform>
   </plugin>
   ```

5. specify the plugin as a <feature> tag in the `Cordova-based` project's config.xml, copy the <feature> node from the corresponding's plugin.xml
   ```xml
   <feature name="TestSwiftPlugin">
     <!-- The value attribute should match the name of the plugin's Swift class -->
     <param name="ios-package" value="TestSwiftPlugin" />
   </feature>
   ```

6. create the Swift plugin class and implement the code under the plugin's src/ios directory

7. using Plugman to install the Swift plugin into the `Cordova-based` iOS project
   ```ruby
   plugman install --platform ios --project platforms/ios/ --plugin plugins/TestSwiftPlugin
   ```

8. launch the .xcworkspace file in Xcode, Xcode will prompt a dialog to confirm convert to current Swift syntax, proceed to convert

9. modify the index.html in the ~/www folder to invoke the cordova plugin
   ```html
   <script type="text/javascript">
   function testPlugin() {
     cordova.plugins.TestSwiftPlugin.coolMethod(
       "testing from webpage...",
       function(success) {
         alert(success);
       },
       function(error) {
         alert(error);
       }
     );
   }
   </script>
   <input type="button" value="test plugin" onClick="javascript:testPlugin()">
   ```

10. disables use of inline scripts in order to mitigate risk of XSS vulnerabilities. To change this add 'unsafe-inline' to default-src

11. rebuild the app with cordova command, it will map the plugin as a feature in the config.xml and also copy all web resources from ~/www to ~/platforms/ios/www
    ```ruby
    cordova build ios
    ```

12. after running the cordova build ios command, restart the Simulator and Xcode (if they were opened while running the cordova build command)

<br/>
