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

open class LoggerithmSLF: LoggerType {
    
    open class var instance  = LoggerithmSLF(logger: Loggerithm.defaultLogger, name: "default")

    open var level: SLFLogLevel {
        get {
            return LoggerithmSLF.toLevel(self.logger.logLevel)
        }
        set {
            self.logger.logLevel = LoggerithmSLF.fromLevel(newValue)
        }
    }
    open var name: LoggerKeyType

    open var logger: Loggerithm
    
    public init(logger: Loggerithm, name: LoggerKeyType) {
        self.logger = logger
        self.name = name
    }

    open func info(_ message: LogMessageType) {
        self.logger.info(message)
    }
    open func error(_ message: LogMessageType) {
        self.logger.error(message)
    }
    open func severe(_ message: LogMessageType) {
        self.logger.error(message)
    }
    open func warn(_ message: LogMessageType) {
        self.logger.warning(message)
    }
    open func debug(_ message: LogMessageType) {
        self.logger.debug(message)
    }
    open func verbose(_ message: LogMessageType) {
        self.logger.verbose(message)
    }

    open func log(_ level: SLFLogLevel,_ message: LogMessageType) {
        self.logger.logWithLevel(LoggerithmSLF.fromLevel(level), message)
    }

    open func isLoggable(_ level: SLFLogLevel) -> Bool {
        return level <= self.level
    }

    open static func toLevel(_ level: LogLevel) -> SLFLogLevel {
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
 
    
    open static func fromLevel(_ level:SLFLogLevel) -> LogLevel {
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

open class LoggerithmSLFFactory: SLFLoggerFactory {
    
    private static var __once: () = {
            let factory = LoggerithmSLFFactory()
            Static.instance = factory
            factory.addLogger(LoggerithmSLF.instance)
        }()
    
    open class var instance : LoggerithmSLFFactory {
        struct Static {
            static var onceToken : Int = 0
            static var instance : LoggerithmSLFFactory?
        }
        
        _ = LoggerithmSLFFactory.__once
        return Static.instance!
    }

    public override init(){
        super.init()
    }
    
    open override func doCreateLogger(_ name: LoggerKeyType) -> LoggerType {
        let logger = Loggerithm()
        return  LoggerithmSLF(logger: logger, name: name)
    }
}
