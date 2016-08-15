# wearable-fitness

Mobile Application to use your health and ﬁtness information. <br/>

This would includes the development at least the following components: <br/>

1. A web service which interface the front-end mobile app with the backend systems <br/>
2. A java-based backend system which process the rule-engine and interface with the oracle database <br/>
3. An authentication & authorization system to provide identity management (using OAuth2.0 authorization framework) and access control to the webservice <br/>
4. Integration with social website (i.e. facebook) with the mobile app (iOS and Android)
5. fitness device (Apple Watch, Android Wear, or even the iPhone or Android phone itself) pairing with the mobile app (iOS and Android) and life-cycle management (device switching)
6. fitness data aggregation from fitness device to mobile app (HealthKit SDK on iOS, Google FIT API / Samsung S Health API on Android)
7. fitness data synchronization (daily sync) with cloud via the restful web service call
8. background service in mobile app to generate local notification based on the rules pushed by the server-side rule engines
9. remote push notification in mobile app to support both platform's built-in push framework (Apple APNS, Google GCM), and 3rd party push SDK (Baidu)
10. bridged notifications, such as new message notifications, are pushed (sync'ed) to the wearable from the connected handheld using standard platform API and require very little or no Wear-specific code. Need special precaution of wearable devices running Tizen OS (Samsung Gear watches) instead of Android Wear OS.

# References:

<b>OAuth 2.0</b>
- http://www.ibm.com/developerworks/websphere/library/techarticles/1208_rasmussen/1208_rasmussen.html <br/>
- https://www.ibm.com/developerworks/library/se-oauthjavapt2/ <br/>
- https://developers.google.com/identity/protocols/OAuth2 <br/>
- https://developers.google.com/oauthplayground/ <br/>

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

<b>Google Fit API</b>
- https://developers.google.com/fit/android/?hl=zh-TW <br/>
- https://developers.google.com/fit/android/get-started?hl=zh-TW#step_5_connect_to_the_fitness_service <br/>
- https://developers.google.com/fit/android/authorization <br/>
- https://developers.google.com/android/guides/api-client <br/>
- https://developers.google.com/fit/android/samples <br/>
- https://developers.google.com/android/guides/http-auth <br/>
- https://developers.google.com/android/guides/api-client#access_the_wearable_api <br/>
- https://support.google.com/fit/?hl=en#6075067 <br/> 

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

<b>Samsung S-Health SDK</b>
- http://shealth.samsung.com/ <br/>
- http://developer.samsung.com/health <br/>

<br/>

<b>Baidu Push Notification SDK</b>
- https://azure.microsoft.com/en-us/documentation/articles/notification-hubs-baidu-china-android-notifications-get-started/ <br/>

<br/>
