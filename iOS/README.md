# Use CocoaPods for dependency management

CocoaPods provides a convenient mechanism for merging 3rd party modules/libraries/frameworks into existing Xcode projects.

<b>CocoaPods Setup Steps</b>

1. Check any installed Ruby versions <br/> 
<i>rvm list known</i> <br/>

2. Install Homebrew <br/> 
<i>ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"</i> <br/> 

3. Upgrade Ruby to 2.2.2 and set to default <br/>
<i>rvm install ruby-2.2.2</i> <br/>
<i>rvm --default use ruby-2.2.0</i> <br/>
<i>ruby -v</i> <br/>

4. Install Cocoa Pods <br/>
<i>sudo gem install cocoapods</i> <br/>

5. Create a Podfile with default settings <br/>
<i>pod init</i> <br/>

6. First time download & install Cocoa Pod Dependencies <br/>
<i>pod install</i> <br/>

7. First time running it will create a .cocoapods folder in the HOME directory and download ALL the dependencies of Cocoa Pod itself, so it can take some time to complete, few hours:( <br/>

8. Make sure to always open the Xcode workspace instead of the project file when building the project <br/> 

9. Now ready to invoke the API from main project source code <br/>

10. Future update of dependencies to new version in Podfile, require to update the local repo <br/>
<i>pod repo update</i><br/>
<i>pod update</i><br/>
<i>pod install</i> <br/>

11. Upgrade of Cocoapods to beta version <br/>
<i>sudo gem uninstall cocoapods</i> <br/>
<i>sudo gem uninstall cocoapods-core</i> <br/>
<i>gem install cocoapods --pre</i> <br/>
<i>pod --version</i> <br/>
<i>pod env</i> <br/>

12. Specify the command-line on particular Cocoapods version, use underscore to surround the version <br/>
<i>pod <b>\_1.1.0.beta.1\_</b> install</i> <br/>

<br/>

#References:

<b>CocoaPods</b> <br/>
- https://cocoapods.org/#get_started <br/>

<br/>

<b>Swift 3</b> <br/>
- https://developer.apple.com/swift/ <br/>
- https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson1.html#//apple_ref/doc/uid/TP40015214-CH3-SW1 <br/>
- https://swift.org/getting-started/ <br/>
- https://swift.org/blog/swift-3-0-preview-1-released/ <br/>
- https://swift.org/migration-guide/ <br/>
- https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TypeCasting.html <br/>
- https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/StringsAndCharacters.html#//apple_ref/doc/uid/TP40014097-CH7-ID285 <br/>
- https://developer.apple.com/swift/blog/?id=23 <br/>
- https://github.com/apple/swift-evolution <br/>
- https://github.com/apple/swift-evolution/blob/master/proposals/0005-objective-c-name-translation.md <br/>

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

<br/>

