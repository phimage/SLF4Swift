# SLF4Swift - Simple Loging Facade for Swift

[![Join the chat at https://gitter.im/phimage/SLF4Swift](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/phimage/SLF4Swift?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat
            )](http://mit-license.org) [![Platform](http://img.shields.io/badge/platform-ios_osx-lightgrey.svg?style=flat
             )](https://developer.apple.com/resources/) [![Language](http://img.shields.io/badge/language-swift-orange.svg?style=flat
             )](https://developer.apple.com/swift) [![Issues](https://img.shields.io/github/issues/phimage/SLF4Swift.svg?style=flat
           )](https://github.com/phimage/Phiole/issues) [![Cocoapod](http://img.shields.io/cocoapods/v/SLF4Swift.svg?style=flat)](http://cocoadocs.org/docsets/SLF4Swift/)

[<img align="left" src="logo-128x128.png" hspace="20">](#logo) Simple Log Facade for Swift serves as a simple facade for logging frameworks allowing the end user to plug in the desired logging framework at deployment time

```swift
let myLogger = SLF4Swift.getLogger("loggerName")
myLogger.info("my info message")
myLogger.log(.Error, "my error message")
```

Not already chosen a logging framework? Don't want to be tied to a specific framework and want to switch (or even combine) easily?
Why not uing a logging [facade](https://en.wikipedia.org/wiki/Facade_pattern)?

A Simple Logging Facade
- make your framework or any part of your codes no dependent to a specific logging frameworks ie. reduce the coupling between an application and any particular logging framework
- allow to log of course with a common interface, avoiding the use of `print()` or `NSLog()` or commented debugging print code
- allow the end user capture the logs and print using his chosen logging frameworks

# For framework or any part of codes not linked to a logging framework
## Getting Logger
Getting the default one
```swift
let myLogger = SLF4Swift.defaultLogger
```
Get logger using a key or create if not exist
```swift
let myLogger = SLF4Swift.createLogger("loggerKey")
```
*Or just get it - here logger could be nil if not already created*
```swift
if let myLogger = SLF4Swift.getLogger("loggerKey") {..}
```

*A key could be a framework name, a class name, a topic name, ....*

If you use a key into a framework, create a `public` constant to allow the end user to decide according to this key what to do with your logs (see <a href="#custom_factories_and_loggers">Custom factories and loggers</a>)

## Printing like any other log framework
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
if myLogger.exec(.Verbose) { // or with closure
	myLogger.log(.Verbose, createLongMessageClosure())
}
```
There is also macro functions for default logger
```swift
SLFLogInfo("info message")
SLFLog(.Verbose, "verbose message")
...
```

By declaring `typealias Log = SLFLogLevel` you can also use default logger like this
```
Log.Info.message("info message")
Log.Verbose.message("verbose message")
Log.Verbose.trace()// print file, function and line

```

# For the end user
## Installing a logger factory
By default is installed a `NullLoggerFactory`, which disable all logs
```swift
SLF4Swift.setSharedFactory(NullLoggerFactory.instance)
```
To enable log, set your `LogFactoryType`
```swift
SLF4Swift.setSharedFactory(MyCustomLoggerFactory())
```

or add `DEBUG` to *"Other Swift Flags"* into *"Swift Compiler - Custom Flags"* section
this add by default a `SLFLoggerFactory`, which use by default `print()`
```swift
SLF4Swift.setSharedFactory(SLFLoggerFactory.sharedInstance)
```

Some backend factories are already implemented into [backend folder](/Backend) (see setup for pod)
```swift
SLF4Swift.setSharedFactory(CocoaLumberjackMacroLoggerFactory.instance)
```

## Custom factories and loggers
You can your create your own `LogFactoryType` and/or `LoggerType`

- then return a logger according to the logger key used by one framework or any part of code

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

To create a custom `LogFactoryType` extend
- `SingleLoggerFactory` if your factory use only one logger
- `ProxyLoggerFactory` if your want to use an another factory and make some adaptations
- `SLFLoggerFactory` and override `doCreateLogger`, if you want to store logger into a `Dictionnary` by key

Some basic loggers are already implemented into [implementation folder](/SLF4Swift/Implementation) (log to a file, using nslog, ...)


# Contributing #
Don't hesitate to fork this repository and PR additionnal `LogFactoryType` for your logging framework

See [CONTRIBUTING.md](CONTRIBUTING.md)

# Setup #
## Using [cocoapods](http://cocoapods.org/) ##

Add `pod 'SLF4Swift'` to your `Podfile` and run `pod install`.

Add `use_frameworks!` to the end of the `Podfile`.

### Backend
[CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)
`pod 'SLF4Swift/CocoaLumberjack'`

[XCGLogger](https://github.com/DaveWoodCom/XCGLogger)
`pod 'SLF4Swift/XCGLogger'`

[SpeedLog](https://github.com/kostiakoval/SpeedLog)
`pod 'SLF4Swift/SpeedLog'`

[Loggerithm](https://github.com/honghaoz/Loggerithm)
`pod 'SLF4Swift/Loggerithm'`

### Make your own framework dependent
In podspec
```ruby
s.dependency 'SLF4Swift'
```

### For additional logger ie. simple implementation ###
Add `pod 'SLF4Swift/Impl'` to your `Podfile`

## Using xcode project ##

1. Drag the.xcodeproj file to your project/workspace or open it to compile it
2. Add the framework to your project

# Issues
- Protocol or protocol implentations do not allow to give default value for functions parameters, caller context cannot be passed to log message (`__FILE__`, `__LINE__`, `__FUNCTION__`). If there is a way, I am interested to learn it

# Licence #
The MIT License (MIT), see LICENSE file

