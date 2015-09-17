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

/* 
 * Register a shared LoggerFactoryType to install a logger system
 * Get loggers, default one or by key
 */
public class SLF4Swift {

    static var initializeToken : dispatch_once_t = 0
    public class func initialize() {
        if _sharedFactory == nil {
            // set default factory according to preprocessor macros
            #if DEBUG
                SLF4Swift.setSharedFactory(SLFLoggerFactory.sharedInstance)
                #else
                SLF4Swift.setSharedFactory(NullLoggerFactory.instance)
            #endif
        }
    }

    private static var _sharedFactory: LoggerFactoryType? = nil

    // Set a custom logger factory
    public class func setSharedFactory(factory: LoggerFactoryType) {
        _sharedFactory = factory
    }
    
    public class func getSharedFactory() -> LoggerFactoryType {
        if _sharedFactory == nil {
            dispatch_once(&SLF4Swift.initializeToken) {
               SLF4Swift.initialize()
            }
        }
       return _sharedFactory!
    }

    public class var defaultLogger: LoggerType {
        return SLF4Swift.getSharedFactory().defaultLogger
    }
    public class func getLogger(name: LoggerKeyType) -> LoggerType? {
        return SLF4Swift.getSharedFactory().getLogger(name)
    }
    public class func createLogger(name: LoggerKeyType) -> LoggerType {
        return SLF4Swift.getSharedFactory().createLogger(name)
    }

    // set null logger factory
    public class func disable() {
        self.setSharedFactory(NullLoggerFactory.instance)
    }
}

public func SLFLogInfo(message: LogMessageType){
    SLF4Swift.defaultLogger.info(message)
}
public func SLFLogError(message: LogMessageType){
    SLF4Swift.defaultLogger.error(message)
}
public func SLFLogSevere(message: LogMessageType){
    SLF4Swift.defaultLogger.severe(message)
}
public func SLFLogWarn(message: LogMessageType){
    SLF4Swift.defaultLogger.warn(message)
}
public func SLFLogDebug(message: LogMessageType){
    SLF4Swift.defaultLogger.debug(message)
}
public func SLFLogVerbose(message: LogMessageType){
    SLF4Swift.defaultLogger.verbose(message)
}
public func SLFLog(level: SLFLogLevel,_ message: LogMessageType){
    SLF4Swift.defaultLogger.log(level, message)
}

public extension SLFLogLevel {

    public func message(message: String) {
        SLF4Swift.defaultLogger.log(self, message)
    }
    
    public func trace(file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UInt = __LINE__) {
        message("\(file):\(function):\(line)")
    }

    public func value(value: Any?) {
        if let v = value {
            message(String(reflecting: v))
        } else {
            message("(nil)")
        }
    }
}
