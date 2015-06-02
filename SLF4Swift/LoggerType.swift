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

public typealias LogMessageType = String

/* a logger */
public protocol LoggerType {
    
    var name: String {get}
    var level: SLFLogLevel {get set}
    
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
    public func error(🚫: NSError) {
        error(🚫.localizedDescription)
    }
    public func severe(message: LogMessageType) {
        log(.Severe, message)
    }
    public func severe(🚫: NSError) {
        severe(🚫.description)
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
        println(message)
    }
    
}

public let SLFDatePrefix: (SLFLogger,SLFLogLevel) -> String = { (logger,level) in
    return NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
}
    