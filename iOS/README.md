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
<i>pod install</i> <br/>

11. Upgrade of Cocoapods to beta version <br/>
<i>sudo gem uninstall cocoapods</i> <br/>
<i>sudo gem uninstall cocoapods-core</i> <br/>
<i>gem install cocoapods --pre</i> <br/>
<i>gem --version</i> <br/>
<i>gem env</i> <br/>

<br/>

#References:

<b>CocoaPods</b> <br/>
https://cocoapods.org/#get_started <br/>

<b>SalesForce Native SDK for Mobile</b> <br/>
https://trailhead.salesforce.com//trail/mobile_sdk_intro <br/>
https://trailhead.salesforce.com/module/mobile_sdk_native_ios <br/>
https://developer.salesforce.com/page/Wiki <br/>
https://developer.salesforce.com/page/An_Introduction_to_Environments <br/>

<br/>

