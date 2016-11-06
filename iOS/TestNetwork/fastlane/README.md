fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Run all iOS tests on an iPhone
### ios build_for_test
```
fastlane ios build_for_test
```
Build and prepare the app for testing
### ios internal
```
fastlane ios internal
```
Release a new beta version on Hockey

This action does the following:



- Ensures a clean git status

- Increment the build number

- Build and sign the app

- Upload the ipa file to hockey

- Post a message to slack containing the download link
### ios deploy
```
fastlane ios deploy
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane/tree/master/fastlane).
