# Use CocoaPods for dependency management

CocoaPods provides a convenient mechanism for merging 3rd party modules/libraries/frameworks into existing Xcode projects.

<b>CocoaPods Setup Steps</b>

1. Check any installed Ruby versions <br/> 
<i>rvm list known</i> <br/>

2. If rvm not installed, install it <br/>
sudo curl -L https://get.rvm.io | bash -s stable --ruby

3. Install Homebrew <br/> 
<i>ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"</i> <br/> 

4. Upgrade Ruby to 2.2.2 and set to default <br/>
<i>rvm install ruby-2.2.2</i> <br/>
<i>rvm --default use ruby-2.2.0</i> <br/>
<i>ruby -v</i> <br/>

5. Install Cocoa Pods <br/>
<i>sudo gem install cocoapods</i> <br/>

6. Create a Podfile with default settings <br/>
<i>pod init</i> <br/>

7. First time download & install Cocoa Pod Dependencies <br/>
<i>pod install</i> <br/>

8. First time running it will create a .cocoapods folder in the HOME directory and download ALL the dependencies of Cocoa Pod itself, so it can take some time to complete, few hours:( <br/>

9. Make sure to always open the Xcode workspace instead of the project file when building the project <br/> 

10. Now ready to invoke the API from main project source code <br/>

11. Future update of dependencies to new version in Podfile, require to update the local repo <br/>
<i>pod repo update</i><br/>
<i>pod update</i><br/>
<i>pod install</i> <br/>

12. Upgrade of Cocoapods to beta version <br/>
<i>sudo gem uninstall cocoapods</i> <br/>
<i>sudo gem uninstall cocoapods-core</i> <br/>
<i>gem install cocoapods --pre</i> <br/>
<i>pod --version</i> <br/>
<i>pod env</i> <br/>

13. Specify the command-line on particular Cocoapods version, use underscore to surround the version <br/>
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

<br/>

