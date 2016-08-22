# Use CocoaPods for dependency management

CocoaPods provides a convenient mechanism for merging 3rd party modules/libraries/frameworks into existing Xcode projects.

<b>CocoaPods Setup Steps</b>

- Check any installed Ruby versions <br/> 
<i><b>rvm list known</b></i> <br/>

- Install Homebrew <br/> 
<i><b>ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"</b></i> <br/> 

- Upgrade Ruby to 2.2.2 and set to default <br/>
<i><b>rvm install ruby-2.2.2</b></i> <br/>
<i><b>rvm --default use ruby-2.2.0</b></i> <br/>
<i><b>ruby -v</b></i> <br/>

- Install Cocoa Pods <br/>
<i><b>sudo gem install cocoapods</b></i> <br/>

- First time download & install Cocoa Pod Dependencies <br/>
<i>execute <b>pod install</b> command from the project root directory, first time running it will create a .cocoapods folder in the HOME directory and download ALL the dependencies of Cocoa Pod itself, so it can take some time to complete, few hours:( </i> <br/>
<i>https://cocoapods.org/#get_started</i> <br/>

