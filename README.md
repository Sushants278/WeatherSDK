WeatherSDK

WeatherSDK is a comprehensive Swift Package designed to seamlessly integrate weather data functionalities into your iOS applications. Whether you’re building with SwiftUI or UIKit, WeatherSDK provides a robust and easy-to-use interface to fetch and display current weather conditions and forecasts for any city.

Table of Contents

	1.	Features
	2.	Prerequisites
	3.	Installation
	4.	Initialization
	5.	Delegate Setup
	6.	Usage
 
Features

	•	Easy Integration: Quickly add WeatherSDK to your project using Swift Package Manager.
	•	SwiftUI & UIKit Support: Compatible with both SwiftUI and UIKit, providing flexible UI options.
	•	Delegate Pattern: Receive callbacks for successful operations and error handling.
	•	Singleton Architecture: Ensures a single instance managing the SDK’s lifecycle.
	•	Comprehensive Documentation: Detailed inline documentation and guides to assist developers.

Prerequisites

Before integrating WeatherSDK into your project, ensure the following:

	•	Xcode Version: 15.0 or later.
	•	iOS Deployment Target: iOS 16.0 or later.
	•	Swift Version: Swift 5.5 or later.

Installation

Swift Package Manager

WeatherSDK is distributed via Swift Package Manager (SPM), making it easy to integrate into your project.

	1.	Open Your Project in Xcode
Launch Xcode and open your project or workspace.
	2.	Add Package Dependency
	•	Navigate to File > Add Packages…
	•	In the search bar, enter the repository URL of WeatherSDK. 

[https://github.com/yourusername/WeatherSDK.git](https://github.com/Sushants278/WeatherSDK.git)

	•	Select the desired version or branch and click Add Package.
	•	Ensure that WeatherSDK is added to the appropriate targets in your project.

3.	Import WeatherSDK
In any Swift file where you intend to use WeatherSDK, import the module:

**import WeatherSDK**

Initialization

Before utilizing any functionalities provided by WeatherSDK, you need to initialize the SDK with your configuration.

1.	Create a Configuration Object
The WeatherConfig class holds the necessary configuration parameters for initializing the SDK, such as the API key.
```
import WeatherSDK

// Initialize the configuration with your API key
let config = WeatherConfig(apiKey: "YOUR_API_KEY_HERE")
```
2.	Initialize the SDK
Call the initializeSDK(withConfig:) method to set up the SDK with your configuration.
```
WeatherSDK.initializeSDK(withConfig: config)
```
Important: Ensure that you perform this initialization early in your app’s lifecycle, such as in the AppDelegate or SceneDelegate, to avoid unexpected behavior.

```
// Example in AppDelegate
import UIKit
import WeatherSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize WeatherSDK
        let config = WeatherConfig(apiKey: "YOUR_API_KEY_HERE")
        WeatherSDK.initializeSDK(withConfig: config)
        
        return true
    }
}
```

Delegate Setup

WeatherSDK utilizes the delegate pattern to inform your application about the completion of tasks and to handle errors gracefully. To receive these callbacks, you need to conform to the WeatherSDKDelegate protocol.

	1.	Conform to WeatherSDKDelegate
Implement the WeatherSDKDelegate protocol in your class.
```
import WeatherSDK
class YourViewController: UIViewController, WeatherSDKDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Additional setup if needed
    }
    
    // MARK: - WeatherSDKDelegate Methods
    
    func weatherSDKDidFinish() {
        // Handle successful completion
        print("WeatherSDK did finish successfully.")
    }
    
    func weatherSDKDidFinishWithError(_ error: Error) {
        // Handle errors
        print("WeatherSDK encountered an error: \(error.localizedDescription)")
    }
}
```

