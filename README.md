# SLF4Swift
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat
            )](http://mit-license.org) [![Platform](http://img.shields.io/badge/platform-iOS_MacOS-lightgrey.svg?style=flat
             )](https://developer.apple.com/resources/) [![Language](http://img.shields.io/badge/language-swift-orange.svg?style=flat
             )](https://developer.apple.com/swift) [![Issues](https://img.shields.io/github/issues/phimage/SLF4Swift.svg?style=flat
           )](https://github.com/phimage/Phiole/issues)

[<img align="left" src="logo-128x128.png" hspace="20">](#logo) Simple Log Facade for Swift serves as a simple facade for logging frameworks allowing the end user to plug in the desired logging framework at deployment time

```swift
let myLogger = SLF4Swift.getLogger("loggerName")
myLogger.info("my info message")
myLogger.log(.Error, "my error message")
```

A Simple Log Facade allow
- to make your framework project or any part of your codes no dependent to a specific logging frameworks
- to log into your framework and let the end user to capture this logs, avoiding the use of `println()` or `NSLog()`

# Installing a logger factory
By default is installed a `SimpleLoggerFactory`, which use `println()` to log
```swift
SLF4Swift.setSharedFactory(SimpleLoggerFactory.sharedInstance)
```
To disable log, a `NullLoggerFactory` can be setted or add `NULL_LOGGER` to *"Other Swift Flags"* into *"Swift Compiler - Custom Flags"* section
```swift
SLF4Swift.setSharedFactory(NullLoggerFactory.instance)
```

You can install with the same way one bridge to a logging framework which implement `LogFactoryType`

Some are already implemented into [bridge folder](/SLF4Swift/Bridge)
```swift
SLF4Swift.setSharedFactory(CocoaLumberJackFactory.instance)
```
Don't hesitate to fork this repository and PR additionnal `LogFactoryType` for your logging framework

# Getting Logger
Getting the default one
```swift
let myLogger = SLF4Swift.defaultLogger()
```
You an create a new logger by specifying a key (could be a class or a framework name)
```swift
let myLogger = SLF4Swift.createLogger("loggerName")

if let myLogger = SLF4Swift.getLogger("loggerName") {..}
// with getLogger a logger could be nil if not created before
```

# Printing #
```swift
myLogger.log(.Error, "my error message") // basic method
// and some shortcut
myLogger.info("my info message")
myLogger.warn("my warn message")
...
// if message compute in a long period of time
if myLogger.isLoggable(.Verbose) {
	myLogger.log(.Verbose, createLongMessageClosure())
}
```


# Setup #
## Using [cocoapods](http://cocoapods.org/) ##

Add `pod 'SLF4Swift', :git => 'https://github.com/phimage/SLF4Swift.git'` to your `Podfile` and run `pod install`.

Add `use_frameworks!` to the end of the `Podfile`.

### For specific log system ###
For [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)
Add `pod 'SLF4Swift/CocoaLumberjack', :git => 'https://github.com/phimage/SLF4Swift.git'`

## Using xcode project ##

1. Drag the.xcodeproj file to your project/workspace or open it to compile it
2. Add the framework to your project

# Roadmap
- Replace `String` by `Printable` object? (then to "\(object)" in code)
- Add some `LogFactoryType` implementations for well known logging frameworks
- Allow to use another key type for logger?

# Licence #
```
The MIT License (MIT)

Copyright (c) 2015 Eric Marchand (phimage)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

# Logo #
By [kodlian](http://www.kodlian.com/), inspired by [apple swift logo](http://en.wikipedia.org/wiki/File:Apple_Swift_Logo.png)
## Why a logo?
I like to see an image for each of my project when I browse them with [SourceTree](http://www.sourcetreeapp.com/)

