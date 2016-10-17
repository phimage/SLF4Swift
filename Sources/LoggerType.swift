//
//  LoggerType.swift
//  SLF4Swift
/*
The MIT License (MIT)

Copyright (c) 2015-2016 Eric Marchand (phimage)

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

public typealias LogMessageType = String // Could change into closure one day

/* a logger */
public protocol LoggerType {
    
    // property
    var name: String {get}
    var level: SLFLogLevel {get set}
    
    // log
    func info(_ message: LogMessageType)
    func error(_ message: LogMessageType)
    func severe(_ message: LogMessageType)
    func warn(_ message: LogMessageType)
    func debug(_ message: LogMessageType)
    func verbose(_ message: LogMessageType)

    // with level
    func log(_ level: SLFLogLevel,_ message: LogMessageType)
    func isLoggable(_ level: SLFLogLevel) -> Bool

}

// Default implementation
public extension LoggerType {
    func info(_ message: LogMessageType) {
        self.log(.info, message)
    }
    func error(_ message: LogMessageType) {
        self.log(.error, message)
    }
    func severe(_ message: LogMessageType) {
        self.log(.severe, message)
    }
    func warn(_ message: LogMessageType) {
        self.log(.warn, message)
    }
    func debug(_ message: LogMessageType) {
        self.log(.debug, message)
    }
    func verbose(_ message: LogMessageType) {
        self.log(.verbose, message)
    }
}

// Some additionnal methods
public extension LoggerType {
    public func warning(_ message: LogMessageType) {
        warn(message)
    }
    public func fatal(_ message: LogMessageType) {
        severe(message)
    }
    public func error(_ 🚫: NSError) {
        error(🚫.localizedDescription)
    }
    public func severe(_ 🚫: NSError) {
        severe(🚫.localizedDescription)
    }

    // execute closure if loggable at specified level
    public func exec(_ logLevel: SLFLogLevel = .debug, closure: () -> () = {}) {
        if (!isLoggable(logLevel)) {
            return
        }
        closure()
    }

    // trace current line info
    // TODO allow to pass this info to backend for all methods
    public func trace(_ level: SLFLogLevel, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        log(level, "\(file):\(function):\(line)")
    }
}

/* Simple println logger. doLog function could be overriden to create more complex logger */
open class SLFLogger: LoggerType {

    open var level: SLFLogLevel
    open var name: LoggerKeyType

    open var prefixClosure: ((SLFLogger,SLFLogLevel) -> String)?

    public init(level: SLFLogLevel, name: LoggerKeyType) {
        self.level = level
        self.name = name
    }
    
    open func info(_ message: LogMessageType) {
        log(.info, message)
    }
    open func error(_ message: LogMessageType) {
        log(.error, message)
    }

    open func severe(_ message: LogMessageType) {
        log(.severe, message)
    }
    open func warn(_ message: LogMessageType) {
        log(.warn, message)
    }
    open func debug(_ message: LogMessageType) {
        log(.debug, message)
    }
    open func verbose(_ message: LogMessageType) {
        log(.verbose, message)
    }

    open func log(_ level: SLFLogLevel,_ message: LogMessageType) {
        assert(!level.isConfig(), "Config levels \(SLFLogLevel.config) cannot be used to log")
        if isLoggable(level) {
            if let closure = prefixClosure {
                let prefix = closure(self,level)
                doLog(level, "\(prefix) \(message)")
            } else {
                doLog(level, "\(message)")
            }
        }
    }
    open func isLoggable(_ level: SLFLogLevel) -> Bool {
        return level.level <= self.level.level
    }
    
    open func doLog(_ level: SLFLogLevel,_ message: LogMessageType) {
        print(message)
    }
    
}

public let SLFDatePrefix: (SLFLogger,SLFLogLevel) -> String = { (logger,level) in
    return DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
}


/* Allow to format log before logging into another logger */
open class FormatterLogger: LoggerType {


    public var name: String = "formatter"
    public var level: SLFLogLevel { get { return logger.level } set { self.logger.level = newValue } }
    public private(set) var logger: LoggerType
    public let format: (SLFLogLevel, LogMessageType) -> (LogMessageType)
 
    public init(logger: LoggerType, format: @escaping (SLFLogLevel, LogMessageType) -> (LogMessageType)) {
        self.logger = logger
        self.format = format
    }
    
    open func info(_ message: LogMessageType) {
        logger.info(format(.info, message))
    }
    open func error(_ message: LogMessageType) {
           logger.info(format(.error, message))
    }
    open func severe(_ message: LogMessageType) {
           logger.info(format(.severe, message))
    }
    open func warn(_ message: LogMessageType) {
       logger.info(format(.warn, message))
    }
    open func debug(_ message: LogMessageType) {
        logger.info(format(.debug, message))
    }
    open func verbose(_ message: LogMessageType) {
        logger.info(format(.verbose, message))
    }
    
    open func log(_ level: SLFLogLevel,_ message: LogMessageType) {
        logger.info(format(level, message))
    }
    open func isLoggable(_ level: SLFLogLevel) -> Bool {
        return logger.isLoggable(level)
    }
 
}

    
