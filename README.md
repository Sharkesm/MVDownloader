# MVDownloader

MVDownloader is a native swift library for making asynchrouns remote requests to download images or JSON format files from the web. 

<!--[![CI Status](https://img.shields.io/travis/Sharkes Monken/MVDownloader.svg?style=flat)](https://travis-ci.org/Sharkes Monken/MVDownloader)-->
<!--[![Version](https://img.shields.io/cocoapods/v/MVDownloader.svg?style=flat)](https://cocoapods.org/pods/MVDownloader)-->
<!--[![License](https://img.shields.io/cocoapods/l/MVDownloader.svg?style=flat)](https://cocoapods.org/pods/MVDownloader)-->
<!--[![Platform](https://img.shields.io/cocoapods/p/MVDownloader.svg?style=flat)](https://cocoapods.org/pods/MVDownloader)-->

## Features 
- [x] Asynchronous image downloading and caching.
- [x] Supports parallel remote requests and caches URL responses 
- [x] Cancelable downloading and re-using resume data from previous requests 
- [x] Fetching of images form cache to improve performance and experience 
- [x] Built-in transition animation when setting images 
- [x] Placeholder replacement support 
- [x] Guarantee same URL request won't be fired several times 
- [x] Custom cache control and configuration 
- [x] Guarantee invalid URL won't be fired 
- [x] Guarantee main thread won't be blocked
- [x] Extends UIImageView and exposes usable methods that support quick way to download images 
- [x] Multiple resources accessing same resource will be backed with the same response 
- [x] Supports decoding of instances of a data type from JSON objects.
- [x] Uses GRC under the hood 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- iOS 10.0+ 
- Xcode 10.0+
- Swift 5.0+

## Dependencies
- [UIKit](https://developer.apple.com/documentation/uikit)

## Installation

MVDownloader is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:
```ruby 
platform :ios, '10.0'
use_frameworks!
pod 'MVDownloader'
```

## Usage

### Shared Instance  
MVDownloader has a shared instance that can be utilised to access all of the exposed methods
```swift
import MVDownloader 

MVDownloader.shared
```

### Download Image
Downloading images using the library can be as easy as providing a proper `URL` request to `downloadImage(from:_, comepletion:_)` method 
and takes over the process of downloading and converting response data to `MVImage` a type of `UIImage`. 
```swift 
import MVDownloader 

MVDownloader.shared.downloadImage(from: url) { (mvimage, error) in
    
    if let downloadedImage = mvimage {
       print("Downloaded image: ", downloadedImage)
    }
    
}
```
Also, there's another way to download images quickly without the hussle writting longer code blocks of such. Checkout `mv_setImage` example. 

### Download Image using `mv_setImage`
MVDownloader library under the hood it extends `UIImageView` and exposes `mv_setUmage(from:_)` method with intention of downloading images and setting them automatically and apply animation transition. 

```swift
import MVDownloader

let imageView = UIImageView()

imageView.mv_setImage(from: url) // Downloads image and sets downloaded image under the hood 
```

### Download JSON 
Decoding of instances of a particular type from JSON objects can be smootly executed by utilising `MVDownloader` ~ `requestDecodable(type:_,from:)` method.  

```swift 
import MVDownloader

/// A type that can convert itself into and out of an external representation.

struct PhotoUrls: Codable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}


guard let pasteBinUrl = URL(string:"https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max&s=d5682032c546a3520465f2965cde1cec") else {
print("Given url is invalid")
return 
}

/// By default, below function utilises `JSONDecoder` object to decode instances of a data type from JSON objects.  

MVDownloader.shared.requestDecodable(type: PhotoUrls.self, from: pasteBinUrl) { (data, error) in

    ...
    // Proceed with data extraction 
    ...
}
```

## Author

Manase Michael, sharkesm@gmail.com

## License

MVDownloader is available under the MIT license. See the LICENSE file for more info.
