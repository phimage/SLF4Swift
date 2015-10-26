//
//  CocoaLumberJack.swift
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
import SLF4Swift
import CocoaLumberjack

/* Log with SwiftLogMacro from CocoaLumberjack */
public class CocoaLumberjackMacroLogger: LoggerType {
    
    public class var instance : CocoaLumberjackMacroLogger {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : CocoaLumberjackMacroLogger?
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = CocoaLumberjackMacroLogger()
        }
        return Static.instance!
    }

    public var level: SLFLogLevel {
        get {
            return CocoaLumberjackMacroLogger.toLevel(defaultDebugLevel)
        }
        set {
            defaultDebugLevel = CocoaLumberjackMacroLogger.fromLevel(newValue)
        }
    }
    public var name: LoggerKeyType = "macro"
    public var isAsynchronous = true

    public func info(message: LogMessageType) {
        DDLogInfo(message, asynchronous: isAsynchronous)
    }
    public func error(message: LogMessageType) {
        DDLogError(message, asynchronous: isAsynchronous)
    }
    public func severe(message: LogMessageType) {
        error(message) // no fatal or severe level
    }
    public func warn(message: LogMessageType) {
        DDLogWarn(message, asynchronous: isAsynchronous)
    }
    public func debug(message: LogMessageType) {
         DDLogDebug(message, asynchronous: isAsynchronous)
    }
    public func verbose(message: LogMessageType) {
         DDLogVerbose(message, asynchronous: isAsynchronous)
    }

    public func log(level: SLFLogLevel,_ message: LogMessageType) {
        SwiftLogMacro(self.isAsynchronous, level: defaultDebugLevel, flag: DDLogFlag.fromLogLevel(CocoaLumberjackMacroLogger.fromLevel(level)), string: message)

    }

    public func isLoggable(level: SLFLogLevel) -> Bool {
        return level <= self.level
    }

    public static func toLevel(level:DDLogLevel) -> SLFLogLevel {
        switch(level){
            case .Off: return SLFLogLevel.Off
            case .Error: return SLFLogLevel.Error
            case .Warning: return SLFLogLevel.Warn
            case .Info: return SLFLogLevel.Info
            case .Debug: return SLFLogLevel.Debug
            case .Verbose: return SLFLogLevel.Verbose
            case .All: return SLFLogLevel.Off
        }
    }
    
    public static func fromLevel(level:SLFLogLevel) -> DDLogLevel {
        switch(level){
        case .Off: return DDLogLevel.Off
        case .Severe: return DDLogLevel.Error
        case .Error: return DDLogLevel.Error
        case .Warn: return DDLogLevel.Warning
        case .Info: return DDLogLevel.Info
        case .Debug: return DDLogLevel.Debug
        case .Verbose: return DDLogLevel.Verbose
        case .All: return DDLogLevel.Off
        }
    }
    
}

public class CocoaLumberjackMacroLoggerFactory: SingleLoggerFactory {
    
    public class var instance : CocoaLumberjackMacroLoggerFactory {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : CocoaLumberjackMacroLoggerFactory?
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = CocoaLumberjackMacroLoggerFactory()
        }
        return Static.instance!
    }
    
    public init(logger: CocoaLumberjackMacroLogger = CocoaLumberjackMacroLogger.instance) {
        super.init(logger: logger)
    }

    public override func removeAllLoggers() {
        // DDLog.removeAllLoggers()
    }
}