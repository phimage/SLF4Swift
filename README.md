# SLF4Swift - Simple Log Facade for Swift
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat
            )](http://mit-license.org) [![Platform](http://img.shields.io/badge/platform-ios_osx-lightgrey.svg?style=flat
             )](https://developer.apple.com/resources/) [![Language](http://img.shields.io/badge/language-swift-orange.svg?style=flat
             )](https://developer.apple.com/swift) [![Issues](https://img.shields.io/github/issues/phimage/SLF4Swift.svg?style=flat
           )](https://github.com/phimage/Phiole/issues) [![Cocoapod](http://img.shields.io/cocoapods/v/SLF4Swift.svg?style=flat)](http://cocoadocs.org/docsets/SLF4Swift/)

[<img align="left" src="logo-128x128.png" hspace="20">](#logo) Simple Log Facade for Swift serves as a simple facade for logging frameworks allowing the end user to plug in the desired logging framework at deployment time in your framework

```swift
let myLogger = SLF4Swift.getLogger("loggerName")
myLogger.info("my info message")
myLogger.log(.Error, "my error message")
```

A Simple Log Facade
- make your framework project or any part of your codes no dependent to an heavy logging frameworks
- allow to log into your framework, avoiding the use of `println()` or `NSLog()`, and let the end user capture this logs

# For framework owner
## Getting Logger
Getting the default one
```swift
let myLogger = SLF4Swift.defaultLogger
```
Get logger or create if not exist
```swift
let myLogger = SLF4Swift.createLogger("loggerKey")
```
Or get it, here logger could be nil
```swift
if let myLogger = SLF4Swift.getLogger("loggerKey") {..}
```

In framework get a logger with a public key, then the end user can create a `LogFactoryType` and decide according to this key the logger to return

## Printing
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
There is macro functions for default logger
```swift
SLFLogInfo("info message")
SLFLog(.Verbose, "verbose message")
...
```

# For the end user
## Installing a logger factory
By default is installed a `NullLoggerFactory`, which disable log
```swift
SLF4Swift.setSharedFactory(NullLoggerFactory.instance)
```
To enable log, set your `LogFactoryType`
```swift
SLF4Swift.setSharedFactory(MyCustomLoggerFactory())
```

or add `DEBUG` to *"Other Swift Flags"* into *"Swift Compiler - Custom Flags"* section
this add by default a `SLFLoggerFactory`, which use by default `println()`
```swift
SLF4Swift.setSharedFactory(SLFLoggerFactory.sharedInstance)
```

## Custom factories and loggers
You can your create your own `LogFactoryType` and/or `LoggerType`

- then return a logger according to the logger key used by one framework

```swift
class MyCustomLoggerFactory: ProxyLoggerFactory {

    func getLogger(name: LoggerKeyType) -> LoggerType? {
    	if name == AFrameWorkKey {
        	return NullLogger.instance // deactive log for specifc logger
        }
        else if name == AnOtherFrameWorkKey {
        	var logger = super.getLogger(name)
            logger.level = .DEBUG // set a specific log level
        	return logger
        }
        return super.getLogger(name)
    }
```

### What you can use

Extend
- `SingleLoggerFactory` if your factory use only one logger
- `ProxyLoggerFactory` if your want to use an another factory and make some adaptations
- `SLFLoggerFactory` and override `doCreateLogger`, if you want to store logger into a `Dictionnary` by key

Some basic loggers are already implemented into [implementation folder](/SLF4Swift/Implementation)

Some backend factories are already implemented into [backend folder](/SLF4Swift/Backend)
```swift
SLF4Swift.setSharedFactory(CocoaLumberJackFactory.instance)
```

Don't hesitate to fork this repository and PR additionnal `LogFactoryType` for your logging framework

# Setup #
## Using [cocoapods](http://cocoapods.org/) ##

Add `pod 'SLF4Swift'` to your `Podfile` and run `pod install`.

Add `use_frameworks!` to the end of the `Podfile`.

### For additional logger ###
Add `pod 'SLF4Swift/Impl'` to your `Podfile`

## Using xcode project ##

1. Drag the.xcodeproj file to your project/workspace or open it to compile it
2. Add the framework to your project

# Roadmap
- Add some `LogFactoryType` implementations for well known logging frameworks
- Replace `String` by `Printable` object or `@autoclosure () -> Printable`?
- Allow to use another key type for logger, `Hashable`?
- Logging methods with arguments to format into `LoggerType`?

# Issues
- Protocol or protocol implentations do not allow to give default value for functions parameters, caller context cannot be passed to log message (`__FILE__`, `__LINE__`, `__FUNCTION__`). If there is a way, I am interested to learn it

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

