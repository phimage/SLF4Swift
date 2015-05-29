//
//  Null.swift
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

public class NullLogger: SimpleLogger {

    public class var instance : NullLogger {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : NullLogger?
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = NullLogger()
        }
        return Static.instance!
    }

    private init() {
        super.init(level: SimpleLogLevel.Off, name: "null")
    }

    override public func isLoggable<T>(level: LogLevelType) -> Bool {
        return false
    }
    override public func doLog(message: String) {
        // do nothing
    }
}

public class NullLoggerFactory: LoggerFactoryType {
    typealias T = NullLogger
    
    public class var instance : NullLoggerFactory {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : NullLoggerFactory?
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = NullLoggerFactory()
        }
        return Static.instance!
    }

    public var defaultLogger: LoggerType = NullLogger.instance
    
    public var allLoggers: [LoggerType] {
        return [defaultLogger]
    }
    
    public func getLogger(name: String) -> LoggerType? {
        return defaultLogger
    }
    public func createLogger(name: String) -> LoggerType {
        return defaultLogger
    }
    public func removeLogger(name: String) -> LoggerType? {
        return nil
    }
    public func removeAllLoggers() {
        // nothing
    }
}