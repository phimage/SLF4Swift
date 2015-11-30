//
//  Loggerithm.swift
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
import Loggerithm

public class LoggerithmSLF: LoggerType {
    
    public class var instance : LoggerithmSLF {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : LoggerithmSLF?
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = LoggerithmSLF(logger: Loggerithm.defaultLogger, name: "default")
        }
        return Static.instance!
    }

    public var level: SLFLogLevel {
        get {
            return LoggerithmSLF.toLevel(self.logger.logLevel)
        }
        set {
            self.logger.logLevel = LoggerithmSLF.fromLevel(newValue)
        }
    }
    public var name: LoggerKeyType

    public var logger: Loggerithm
    
    public init(logger: Loggerithm, name: LoggerKeyType) {
        self.logger = logger
        self.name = name
    }

    public func info(message: LogMessageType) {
        self.logger.info(message)
    }
    public func error(message: LogMessageType) {
        self.logger.error(message)
    }
    public func severe(message: LogMessageType) {
        self.logger.error(message)
    }
    public func warn(message: LogMessageType) {
        self.logger.warning(message)
    }
    public func debug(message: LogMessageType) {
        self.logger.debug(message)
    }
    public func verbose(message: LogMessageType) {
        self.logger.verbose(message)
    }

    public func log(level: SLFLogLevel,_ message: LogMessageType) {
        self.logger.logWithLevel(LoggerithmSLF.fromLevel(level), message)
    }

    public func isLoggable(level: SLFLogLevel) -> Bool {
        return level <= self.level
    }

    public static func toLevel(level: LogLevel) -> SLFLogLevel {
        switch(level){
        case .Off: return SLFLogLevel.Off
        case .Error: return SLFLogLevel.Error
        case .Warning: return SLFLogLevel.Warn
        case .Info: return SLFLogLevel.Info
        case .Debug: return SLFLogLevel.Debug
        case .Verbose: return SLFLogLevel.Verbose
        case .All: return SLFLogLevel.All
        }
    }
 
    
    public static func fromLevel(level:SLFLogLevel) -> LogLevel {
        switch(level){
        case .Off: return LogLevel.Off
        case .Severe: return LogLevel.Error
        case .Error: return LogLevel.Error
        case .Warn: return LogLevel.Warning
        case .Info: return LogLevel.Info
        case .Debug: return LogLevel.Debug
        case .Verbose: return LogLevel.Verbose
        case .All: return LogLevel.All
        }
    }
    
}

public class LoggerithmSLFFactory: SLFLoggerFactory {
    
    public class var instance : LoggerithmSLFFactory {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : LoggerithmSLFFactory?
        }
        
        dispatch_once(&Static.onceToken) {
            let factory = LoggerithmSLFFactory()
            Static.instance = factory
            factory.addLogger(LoggerithmSLF.instance)
        }
        return Static.instance!
    }

    public override init(){
        super.init()
    }
    
    public override func doCreateLogger(name: LoggerKeyType) -> LoggerType {
        let logger = Loggerithm()
        return  LoggerithmSLF(logger: logger, name: name)
    }
}