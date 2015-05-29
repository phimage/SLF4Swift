//
//  SLF4Swift.swift
//  SLF4Swift
/*
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
*/

import Foundation

/* register a shared LoggerFactoryType to install a logger system */
public class SLF4Swift {

    public class func initialize() {
        // set default factory according to preprocessor macros
        #if NULL_LOGGER
        SLF4Swift.setSharedFactory(NullLoggerFactory.instance)
        #else
        SLF4Swift.setSharedFactory(SimpleLoggerFactory.sharedInstance)
        #endif
    }

    private static var _sharedFactory: LoggerFactoryType? = nil

    public class func setSharedFactory(factory: LoggerFactoryType) {
        _sharedFactory = factory
    }
    
    public class func getSharedFactory() -> LoggerFactoryType {
        if _sharedFactory == nil {
            initialize()
        }
       return _sharedFactory!
    }

    public class func defaultLogger() -> LoggerType {
        let factory: LoggerFactoryType = SLF4Swift.getSharedFactory()
        return factory.defaultLogger
    }
    public class func getLogger(name: String) -> LoggerType? {
        let factory: LoggerFactoryType = SLF4Swift.getSharedFactory()
        return factory.getLogger(name)
    }
    public class func createLogger(name: String) -> LoggerType {
        let factory: LoggerFactoryType = SLF4Swift.getSharedFactory()
        return factory.createLogger(name)
    }
}

public func SLFLogInfo(message: String){
    SLF4Swift.defaultLogger().info(message)
}
public func SLFLogError(message: String){
    SLF4Swift.defaultLogger().error(message)
}
public func SLFLogSevere(message: String){
    SLF4Swift.defaultLogger().severe(message)
}
public func SLFLogWarn(message: String){
    SLF4Swift.defaultLogger().warn(message)
}
public func SLFLogDebug(message: String){
    SLF4Swift.defaultLogger().debug(message)
}
public func SLFLogVerbose(message: String){
    SLF4Swift.defaultLogger().verbose(message)
}
public func SLFLog(level: SimpleLogLevel, message: String){
    SLF4Swift.defaultLogger().log(level, message)
}
