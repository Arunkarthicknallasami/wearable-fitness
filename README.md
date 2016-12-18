# wearable-fitness

Mobile Application to use your health and ﬁtness information. <br/>

This would includes the development at least the following components: <br/>

1. A web service (Cloud CRM solution, i.e. [SalesForce App Cloud](https://www.salesforce.com/ap/platform/overview/) or [Microsoft Dynamics CRM](https://www.microsoft.com/en-us/dynamics/crm.aspx)) which interface the front-end mobile app with the backend systems <br/>
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

<b>What is Salesforce </b><br/>
- https://www.salesforce.com/products/what-is-salesforce/ <br/>

<b>Introduction of Salesforce App Cloud Platform</b> <br/>
- https://www.salesforce.com/platform/overview/ <br/>

<b>Introduction to Salesforce Environments</b> <br/>
- https://developer.salesforce.com/page/An_Introduction_to_Environments <br/>

<b>Integrating with Force.com Platform</b> <br/>
- https://developer.salesforce.com/page/Integrating_with_the_Force.com_Platform <br/>
- https://developer.salesforce.com/docs/atlas.en-us.workbook.meta/workbook/workshops_intro.htm?utm_campaign=getting-started&utm_source=DSC&utm_medium=website <br/>

<b>Introduction to Force.com REST API</b> <br/>
- https://developer.salesforce.com/docs/atlas.en-us.202.0.api_rest.meta/api_rest/intro_what_is_rest_api.htm  <br/>

<b>SOAP API Implementation Consideration</b> <br/>
- https://developer.salesforce.com/docs/atlas.en-us.202.0.api.meta/api/implementation_considerations.htm?SearchType=Stem <br/>

<b>Salesforce Limits Quick Reference Guide</b> <br/>
- https://developer.salesforce.com/docs/atlas.en-us.salesforce_app_limits_cheatsheet.meta/salesforce_app_limits_cheatsheet/salesforce_app_limits_overview.htm <br/>

<b>Force.com Sites Limit and Billing</b> <br/>
- https://help.salesforce.com/HTViewHelpDoc?id=sites_limits.htm&siteLang=en_us <br/>

<b>Caching Force.com Sites Pages</b> <br/>
- https://help.salesforce.com/HTViewHelpDoc?id=sites_caching.htm&language=en_US <br/>

<b>Viewing 24-Hour Force.com Sites Usage History</b> <br/>
- https://help.salesforce.com/HTViewHelpDoc?id=sites_usage_history.htm&language=en_US <br/>

<b>Salesforce Mobile SDK</b> <br/>
- https://developer.salesforce.com/page/Mobile <br/>
- https://developer.salesforce.com/blogs/engineering/2015/02/salesforce-mobile-sdk-3-1-unified-app-architecture-brings-unparalleled-flexibility.html <br/>
- https://developer.salesforce.com/blogs/engineering/2016/01/salesforce-mobile-sdk-4-0-flexible-libraries-native-hybrid-app-development.html <br/>
- https://trailhead.salesforce.com//trail/mobile_sdk_intro <br/>
- https://trailhead.salesforce.com/module/mobile_sdk_native_ios <br/>

<b>Salesforce Mobile SDK (news and update)</b>
- https://developer.salesforce.com/page/Mobile <br/>

<b>Salesforce SDK for Android</b>
- https://github.com/forcedotcom/SalesforceMobileSDK-Android <br/>

<b>Disabling TLS 1.0: Preparing Mobile SDK Apps for the Big Change</b>
- https://developer.salesforce.com/blogs/engineering/2016/03/disabling-tls-1-0-preparing-mobile-sdk-apps-big-change.html <br/>

<br/>
