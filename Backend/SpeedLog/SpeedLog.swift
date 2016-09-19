//
//  SpeedLog.swift
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
#if EXTERNAL
    import SLF4Swift
#endif
import SpeedLog

open class SpeedLogSLFLogger: LoggerType {
    
    open class var instance  = SpeedLogSLFLogger(level: SLFLogLevel.Debug)
    
    fileprivate init(level: SLFLogLevel) {
        self.level = level
    }

    open var level: SLFLogLevel
    open var name: LoggerKeyType = "instance"
    
    open func log(_ level: SLFLogLevel,_ message: LogMessageType) {
        if isLoggable(level) {
            SpeedLog.println(message)
        }
    }

    open func isLoggable(_ level: SLFLogLevel) -> Bool {
        return level <= self.level
    }
    
}

open class SpeedLogSLFLoggerFactory: SingleLoggerFactory {

    open class var instance = SpeedLogSLFLoggerFactory()

    public init(logger: SpeedLogSLFLogger = SpeedLogSLFLogger.instance) {
        super.init(logger: logger)
    }

    open override func removeAllLoggers() {
        
    }
}
