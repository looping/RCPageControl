# RCPageControl

[![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)](https://github.com/RidgeCorn/RCPageControl/blob/master/LICENSE)
[![Build Platform](https://cocoapod-badges.herokuapp.com/p/RCPageControl/badge.png)](https://github.com/RidgeCorn/RCPageControl)
[![Build Version](https://cocoapod-badges.herokuapp.com/v/RCPageControl/badge.png)](https://github.com/RidgeCorn/RCPageControl)
[![Build Status](https://travis-ci.org/RidgeCorn/RCPageControl.png?branch=master)](https://travis-ci.org/RidgeCorn/RCPageControl)

Yet another page control for iOS, with awesome animation powered by [Facebook pop library](https://github.com/facebook/pop).

<img src="https://github.com/RidgeCorn/RCPageControl/raw/master/RCPageControlDemo.gif" alt="RCPageControlDemo" width="320" height="568" />

**Any idea to make this more awesome? Please feel free to open an issue or make a PR.**


## Requirements
* Xcode 10.0 or higher
* iOS 8.0 or higher
* ARC
* [pop animation library](https://github.com/facebook/pop)


## Run Example

In your terminal,

``` bash
cd [workspace]/RCPageControl/RCPageControlExample
pod install
```

Then,

``` bash
open RCPageControlExample.xcworkspace
```
or typing `xed .`.


## Installation

The recommended approach for installating `RCPageControl` is via the [CocoaPods](http://cocoapods.org/) package manager.

In your `Podfile`, add a line shows below:

``` bash
pod 'RCPageControl'
```

Then,

``` bash
pod update
```


## Usage

The API of `RCPageControl` is highly similar as `UIPageControl`.

### 1. First of all

Use by including the following import:

##### Objective-C

```objective-c
#import <RCPageControl/RCPageControl.h>
```

or if you're using the embedded framework:

```objective-c
@import RCPageControl;
```

##### Swift

```swift
import RCPageControl
```

### 2. Initialization

#### Using `initWithFrame:`

##### Objective-C

```objective-c
RCPageControl *pageControl = [RCPageControl initWithFrame:CGRectMake(0, 0, 100, 10)];
```

##### Swift

```swift
let pageControl = RCPageControl(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
```

#### Using `initWithNumberOfPages:`

##### Objective-C

```objective-c
RCPageControl *pageControl = [RCPageControl initWithNumberOfPages:5];
```

##### Swift

```swift
let pageControl = RCPageControl(numberOfPages: 5)
```

### 3. Callback

#### Using `UIControlEvent`

##### Objective-C

```objective-c
[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
```

##### Swift

```swift
pageControl?.addTarget(self, action: #selector(changePage(sender:)), for: .valueChanged)
```

#### Using `RCCurrentPageChangedBlock`

##### Objective-C

```objective-c
[pageControl setCurrentPageChangedBlock:^(RCPageControl *pageControl) {
    // Code here
}];
```

##### Swift

```swift
pageControl?.currentPageChangedBlock = { (pageControl) in
    // Code here
}
```

### 4. Properties

Just list new properties of `RCPageControl`.

- **indicatorDotGap**
The distance between two dots from their edges. Default value is `10.0`, cannot be smaller than `2.0`.

- **indicatorDotWidth**
The width of dot, you may assume that the dot is likes a circle. Default value is `4.0`, cannot be smaller than `2.0`.

- **animationSpeed** & **animationBounciness**

We use `POPSpringAnimation` for dots animation. See [POPSpringAnimation.h](https://github.com/facebook/pop/blob/master/pop/POPSpringAnimation.h) for more info.

- **animationDuration**

The duration for `UIView animation`. Using in `_indicatorIndexLabel` animation. Only available when `hideCurrentPageIndex` is setting to `NO`. Default is `0.6`. 

- **animationScaleFactor**

The dot scale factor. Using to calculate the width of current dot. Default is `2`.

- **hideCurrentPageIndex**

When set to `YES`, the `Page Index Label` will be hidden. Default is `NO`. The displayed page is start from `1`.

- **disableAnimation**

When set to `YES`, all indicator dots' changing animation will be disabled. Default is `NO`.

- **pageIndicatorTintColor**

The dot background color. Default is `[UIColor lightTextColor]`.

- **currentPageIndicatorTintColor**

The current dot background color. Default is `[UIColor whiteColor]`.

- **currentPageIndexTextTintColor**

The `Page Index Label`'s `TextColor`. Default is `[UIColor darkTextColor]`.

- **currentPageIndexTextFont**

The `Page Index Label`'s `Font`. Default is `[UIFont systemFontOfSize:0]`. The font size will automatically adjusts by the value of `indicatorDotWidth` and `animationScaleFactor`


## License

RCPageControl is available under the MIT license. See the [LICENSE](https://github.com/RidgeCorn/RCPageControl/blob/master/LICENSE) file for more info.
