# CleanJSON

[![CI Status](https://img.shields.io/travis/Pircate/CleanJSON.svg?style=flat)](https://travis-ci.org/Pircate/CleanJSON)
[![Version](https://img.shields.io/cocoapods/v/CleanJSON.svg?style=flat)](https://cocoapods.org/pods/CleanJSON)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/CleanJSON.svg?style=flat)](https://cocoapods.org/pods/CleanJSON)
[![Platform](https://img.shields.io/cocoapods/p/CleanJSON.svg?style=flat)](https://cocoapods.org/pods/CleanJSON)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CleanJSON is available through [CocoaPods](https://cocoapods.org) or [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Podfile or Cartfile:

#### Podfile
```ruby
pod 'CleanJSON'
```
#### Cartfile
```ruby
githut "Pircate/CleanJSON"
```

## Import
```swift
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
