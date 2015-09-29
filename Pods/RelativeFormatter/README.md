# RelativeFormatter
NSDate swift extension to format dates according to current date.

## Features

- [x] Format NSDate as Time ago
- [x] Format NSDate as Time ahead

## Requirements

- iOS 7.0+ / Mac OS X 10.9+
- Xcode 6.3

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks.**
>


### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate RelativeFormatter into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'RelativeFormatter'
```

Then, run the following command:

```bash
$ pod install
```

### How To Use

RelativeFormatter is just an NSDate extension, you can use it with any NSDate object:

If you have an NSDate representing a date 2 months ago just use:

```swift
	oldDate.relativeFormatted()
```

And you'll get:

"2 months ago"

It also works for ahead dates (date in 3 years):

```swift
	futureDate.relativeFormatted()
```

will return:

"In 3 years"

### Languages

RelativeFormatter includes localization for:

- [x] English
- [x] Spanish

If you can to include a new language please create a pull request
