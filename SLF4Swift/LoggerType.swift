//
//  LoggerType.swift
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

public typealias LogMessageType = String // Could change into closure one day

/* a logger */
public protocol LoggerType {
    
    // property
    var name: String {get}
    var level: SLFLogLevel {get set}
    
    // log
    func info(message: LogMessageType)
    func error(message: LogMessageType)
    func severe(message: LogMessageType)
    func warn(message: LogMessageType)
    func debug(message: LogMessageType)
    func verbose(message: LogMessageType)

    // with level
    func log(level: SLFLogLevel,_ message: LogMessageType)
    func isLoggable(level: SLFLogLevel) -> Bool

}

// Default implementation
public extension LoggerType {
    func info(message: LogMessageType) {
        self.log(.Info, message)
    }
    func error(message: LogMessageType) {
        self.log(.Error, message)
    }
    func severe(message: LogMessageType) {
        self.log(.Severe, message)
    }
    func warn(message: LogMessageType) {
        self.log(.Warn, message)
    }
    func debug(message: LogMessageType) {
        self.log(.Debug, message)
    }
    func verbose(message: LogMessageType) {
        self.log(.Verbose, message)
    }
}

// Some additionnal methods
public extension LoggerType {
    public func warning(message: LogMessageType) {
        warn(message)
    }
    public func fatal(message: LogMessageType) {
        severe(message)
    }
    public func error(🚫: NSError) {
        error(🚫.localizedDescription)
    }
    public func severe(🚫: NSError) {
        severe(🚫.localizedDescription)
    }

    // execute closure if loggable at specified level
    public func exec(logLevel: SLFLogLevel = .Debug, closure: () -> () = {}) {
        if (!isLoggable(logLevel)) {
            return
        }
        closure()
    }

    // trace current line info
    // TODO allow to pass this info to backend for all methods
    public func trace(level: SLFLogLevel, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UInt = __LINE__) {
        log(level, "\(file):\(function):\(line)")
    }
}

/* Simple println logger. doLog function could be overriden to create more complex logger */
public class SLFLogger: LoggerType {

    public var level: SLFLogLevel
    public var name: LoggerKeyType

    public var prefixClosure: ((SLFLogger,SLFLogLevel) -> String)?

    public init(level: SLFLogLevel, name: LoggerKeyType) {
        self.level = level
        self.name = name
    }
    
    public func info(message: LogMessageType) {
        log(.Info, message)
    }
    public func error(message: LogMessageType) {
        log(.Error, message)
    }

    public func severe(message: LogMessageType) {
        log(.Severe, message)
    }
    public func warn(message: LogMessageType) {
        log(.Warn, message)
    }
    public func debug(message: LogMessageType) {
        log(.Debug, message)
    }
    public func verbose(message: LogMessageType) {
        log(.Verbose, message)
    }

    public func log(level: SLFLogLevel,_ message: LogMessageType) {
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
    public func isLoggable(level: SLFLogLevel) -> Bool {
        return level.level <= self.level.level
    }
    
    public func doLog(level: SLFLogLevel,_ message: LogMessageType) {
        print(message)
    }
    
}

public let SLFDatePrefix: (SLFLogger,SLFLogLevel) -> String = { (logger,level) in
    return NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
}
    