
[![License][license-image]][license-url]
[![Swift Version][swift-image]][swift-url]
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](https://www.apple.com)

# RecipeApp

The weather forecast app provides a user-friendly and intuitive interface to get up-to-date weather information for various cities. The following are its key features:
Ability to search for a city by its name right on the home screen and in the list of favorite cities.
Adding cities to favorites for quick access to weather information.
Pull-To-Refresh gesture for instant weather updates.
Pagination for easy viewing of information about 10 cities on each page.
Automatically refresh the list of favorite cities after they are added to instantly track changes.
Automatically switch between light and dark theme for comfortable use based on time.
Utilizing ViewModel for efficient data management and presentation.
Excellent performance by loading weather information in pagination, minimizing the load on the user's device.

![MainLight][screenshot1-url]
![MainDark][screenshot2-url]

## Features

- [x] Search for a city by city name on the home screen and in favorites
- [x] Add to favorites
- [x] Pull-To-Refresh
- [x] Pagination with loading of 10 cities each
- [x] Load screen with static picture
- [x] RealmSwift database for storing favorite cities
- [x] Automatic updating of favorites after adding to the list
- [x] Light dark theme
- [x] ViewModel

## Requirements

- iOS 11+
- Xcode 14.3.1

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install by adding to your `Podfile`:

1. Create a Podfile if you don't already have one. From the root of your project directory, run the following command: `pod init`

2. To your Podfile, add the Firebase pods:

```swift
platform :ios, '9.0'
pod 'RxSwift'
pod 'RxCocoa'
pod 'RxGesture'
pod 'RxDataSources'
pod 'RxViewController'
pod 'RxKeyboard'
pod 'RealmSwift'
pod 'SnapKit'
```

4. Install the pods, then open your .xcworkspace file to see the project in Xcode: `pod install --repo-update`

5. Open: Weather.xcworkspace

## Meta

Link to used icons: 

1. https://www.flaticon.com/free-icon/home_1946488

2. https://www.flaticon.com/free-icon/heart_10905048

3. https://www.flaticon.com/free-icon/heart_833472


Distributed under the GPL-2.0 license. See ``LICENSE`` for more information.

[https://github.com/TwinkleFoxy/github-link](https://github.com/TwinkleFoxy/)

[swift-url]: https://swift.org/
[license-url]: https://github.com/TwinkleFoxy/Weather/blob/main/LICENSE
[license-image]: https://img.shields.io/github/license/TwinkleFoxy/Weather?color=brightgreen
[license-url]: https://github.com/TwinkleFoxy/Weather/blob/main/LICENSE
[screenshot1-url]: https://github.com/TwinkleFoxy/Weather/blob/main/Screenshots/MainLight.png
[screenshot2-url]: https://github.com/TwinkleFoxy/Weather/blob/main/Screenshots/MainDark.png
