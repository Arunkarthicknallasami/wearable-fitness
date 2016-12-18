# Android Build

<b>Development Environment</b>
- Android Studio 2.1 or higher
- Android SDK 23 (Salesforce SDK 4.3 not yet support Android SDK 24)
- Android SDK Build Tools 23.0 or higher
- Gradle 2.10 or higher
- JDK 1.8 or higher
- Maven 3.0.5
- Salesforce SDK for Android 4.3 
  - SalesforceSDK
  - SmartStore
  - SmartSync

<br/>

<b>3rd Party Libraries Dependencies</b>
- Google GSON (com.google.code.gson:gson:2.7)
- Guaba (com.google.guava:guava:18.0) required by SalesforceSDK
- okHTTP (com.squareup.okhttp3:okhttp:3.2.0) required by SalesforceSDK
- okio (com.squareup.okio:okio:1.9.0) required by SalesforceSDK
- SQLCipher (net.zetetic:android-database-sqlcipher:3.5.2) required by SmartStore

<br/>

# Git Submodule:
We use git submodule for project dependency management on Android. 
<br/>

<b>Creating the submodule</b><br/>
- git submodule add <i>git_repo_url</i> libs/<i>submodule_name</i> -b <i>git_branch_name</i> 
- git config --file=.gitmodules submodule.libs/<i>submodule_name</i>.branch.<i> <i>git_branch_name</i>
- git submodule sync
- git submodule update --remote

<br/>

<b>Cloning the repo with fetching the submodule</b><br/>
Recursively clone the repo if the repo has a submodule file. <br/>
- git clone --recursive <i>git_repo_url</i> -b <i>git_branch_name</i> --single-branch

<br/>

<b>Cloning the repo without fetching the submodule 1</b><br/>
Clone the repo without fetching the submodule, use git credential store command to cache the credentials.<br/>
- git config --global credential.helper store
- git clone <i>git_repo_url</i> -b <i>git_branch_name</i>
- git submodule update --init

<br/>

<b>Cloning the repo without fetching the submodule 2</b><br/>
Clone the repo without fetching the submodule, while username and password are injected at run-time.<br/>
- git clone <i>git_repo_url</i> -b <i>git_branch_name</i>
- git config --file=.gitmodules.submodule.libs/<i>submodule_name</i>.url <i>git_repo_url</i>
- git submodule sync
- git submodule update --init

<br/>

# References:

<b>Google Fit API</b>
- https://developers.google.com/fit/android/?hl=zh-TW <br/>
- https://developers.google.com/fit/android/get-started?hl=zh-TW#step_5_connect_to_the_fitness_service <br/>
- https://developers.google.com/fit/android/authorization <br/>
- https://developers.google.com/android/guides/api-client <br/>
- https://developers.google.com/fit/android/samples <br/>
- https://developers.google.com/android/guides/http-auth <br/>
- https://developers.google.com/android/guides/api-client#access_the_wearable_api <br/>
- https://support.google.com/fit/?hl=en#6075067  

<br/>

<b>Facebook Mobile SDK for Android</b>
-  https://developers.facebook.com/quickstarts/ <br/>
-  https://developers.facebook.com/docs/facebook-login/permissions/#reference-public_profile <br/>
-  https://developers.facebook.com/docs/facebook-login/access-tokens <br/>
-  https://developers.facebook.com/docs/facebook-login/access-tokens/expiration-and-extension <br/>
-  https://developers.facebook.com/apps/ <br/>
-  https://developers.facebook.com/docs/facebook-login/android <br/>
-  https://developers.facebook.com/docs/facebook-login/android/accesstokens <br/>
-  https://developers.facebook.com/docs/facebook-login/android/permissions <br/>
-  https://developers.facebook.com/docs/android/graph <br/>
-  https://developers.facebook.com/docs/reference/android/current/class/GraphRequest/ <br/>
-  https://developers.facebook.com/tools/explorer <br/>

<br/>

<b>Push Notification for Wearable</b>
- https://developer.android.com/wear/index.html <br/>
- https://developer.android.com/training/building-wearables.html <br/>
- https://developer.android.com/training/wearables/apps/creating.html <br/>
- https://developer.android.com/training/wearables/notifications/creating.html <br/>
- http://android-developers.blogspot.hk/2016/05/android-wear-20-developer-preview.html <br/>
- http://android-developers.blogspot.hk/2016/07/android-wear-20-developer-preview-2.html <br/>
- https://developer.android.com/wear/preview/features/notifications.html <br/>
- http://www.samsung.com/us/support/answer/ANS00032965/ <br/>

<br/>

<b>Firebase Cloud Messaging (FCM)</b>
- https://developers.google.com/cloud-messaging/android/android-migrate-fcm <br/>

<br/>

<b>Samsung S-Health SDK</b>
- http://shealth.samsung.com/ <br/>
- http://developer.samsung.com/health <br/>

<b>Baidu Push Notification SDK</b>
- https://azure.microsoft.com/en-us/documentation/articles/notification-hubs-baidu-china-android-notifications-get-started/ <br/>

<br/>
