//
//  Swell.swift
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
import Swell

open class SwellSLF: LoggerType {
    
    open class var instance = SwellSLF(logger: Swell.getLogger("Shared"))

    open var level: SLFLogLevel {
        get {
            return SwellSLF.toLevel(self.logger.level)
        }
        set {
            self.logger.level = SwellSLF.fromLevel(newValue)
        }
    }
    open var name: LoggerKeyType {
        return self.logger.name
    }

    open var logger: Logger
    
    public init(logger: Logger) {
        self.logger = logger
    }

    open func info(_ message: LogMessageType) {
        self.logger.info(message)
    }
    open func error(_ message: LogMessageType) {
        self.logger.error(message)
    }
    open func severe(_ message: LogMessageType) {
        self.logger.severe(message)
    }
    open func warn(_ message: LogMessageType) {
        self.logger.warn(message)
    }
    open func debug(_ message: LogMessageType) {
        self.logger.debug(message)
    }
    open func verbose(_ message: LogMessageType) {
        self.logger.trace(message)
    }

    open func log(_ level: SLFLogLevel,_ message: LogMessageType) {
        self.logger.log(SwellSLF.fromLevel(level), message: message)
    }

    open func isLoggable(_ level: SLFLogLevel) -> Bool {
        return level <= self.level
    }

    open static func toLevel(_ level:LogLevel) -> SLFLogLevel {
        let predef = PredefinedLevel(rawValue: level.level)!
        switch(predef){
        case .severe: return SLFLogLevel.Severe
        case .error: return SLFLogLevel.Error
        case .warn: return SLFLogLevel.Warn
        case .info: return SLFLogLevel.Info
        case .debug: return SLFLogLevel.Debug
        case .trace: return SLFLogLevel.Verbose
        }
    }
 
    
    open static func fromLevel(_ level:SLFLogLevel) -> LogLevel {
        switch(level){
        case .Off: return LogLevel.getLevel(PredefinedLevel.severe) // XXX not working
        case .Severe: return LogLevel.getLevel(PredefinedLevel.severe)
        case .Error: return LogLevel.getLevel(PredefinedLevel.error)
        case .Warn: return LogLevel.getLevel(PredefinedLevel.warn)
        case .Info: return LogLevel.getLevel(PredefinedLevel.info)
        case .Debug: return LogLevel.getLevel(PredefinedLevel.debug)
        case .Verbose: return LogLevel.getLevel(PredefinedLevel.trace)
        case .All: return LogLevel.getLevel(PredefinedLevel.trace)
        }
    }
    
}

open class SwellSLFFactory: SLFLoggerFactory {

    open class var instance = SwellSLFFactory()

    public override init(){
        super.init()
    }

    open override func doCreateLogger(_ name: LoggerKeyType) -> LoggerType {
        let logger = Swell.getLogger(name)
        return  SwellSLF(logger: logger)
    }
}
