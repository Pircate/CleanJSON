# CleanJSON

[![Version](https://img.shields.io/cocoapods/v/CleanJSON.svg?style=flat)](http://cocoapods.org/pods/CleanJSON)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/CleanJSON.svg?style=flat)](http://cocoapods.org/pods/CleanJSON)
![iOS 9.0+](https://img.shields.io/badge/iOS-9.0%2B-blue.svg)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 9.0+
* Swift 4

## Installation

CleanJSON is available through [CocoaPods](http://cocoapods.org) or [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Podfile or Cartfile:

### CocoaPods

```ruby
pod 'CleanJSON'
```

### Carthage
```ruby
github "Pircate/CleanJSON"
```

## Import

``` swift
import CleanJSON
```
## Usage
```swift
let decoder = CleanJSONDecoder()
try decoder.decode(Model.self, from: data)
```

## Author

Pircate, gao497868860@163.com

## License

CleanJSON is available under the MIT license. See the LICENSE file for more info.
