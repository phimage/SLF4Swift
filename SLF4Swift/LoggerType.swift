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
    var level: LogLevelType {get}
    
    func info(message: LogMessageType)
    func error(message: LogMessageType)
    func severe(message: LogMessageType)
    func warn(message: LogMessageType)
    func debug(message: LogMessageType)
    func verbose(message: LogMessageType)

    func log(level: LogLevelType,_ message: LogMessageType)
    func isLoggable(level: LogLevelType) -> Bool
    
    // enum
    func log(level: SLFLogLevel,_ message: LogMessageType)
    func isLoggable(level: SLFLogLevel) -> Bool
    
}

/* Simple println logger. doLog function could be overriden to create more complex logger */
public class SLFLogger : LoggerType {

    public var level: LogLevelType
    public var name: LoggerKeyType

    public var prefixClosure: (() -> String)?
    
    public init(level: SLFLogLevel, name: LoggerKeyType) {
        self.level = level
        self.name = name
    }
    
    public func info(message: LogMessageType) {
        log(SLFLogLevel.Info, message)
    }
    public func error(message: LogMessageType) {
        log(SLFLogLevel.Error, message)
    }
    public func severe(message: LogMessageType) {
        log(SLFLogLevel.Severe, message)
    }
    public func warn(message: LogMessageType) {
        log(SLFLogLevel.Warn, message)
    }
    public func debug(message: LogMessageType) {
        log(SLFLogLevel.Debug, message)
    }
    public func verbose(message: LogMessageType) {
        log(SLFLogLevel.Verbose, message)
    }

    public func log(level: LogLevelType,_ message: LogMessageType) {
        if isLoggable(level) {
            if let closure = prefixClosure {
                let prefix = closure()
                doLog("\(prefix)\(message)")
            } else {
                doLog("\(message)")
            }
        }
    }
    public func isLoggable(level: LogLevelType) -> Bool {
        return self.level.level <= level.level
    }
    
    
    public func log(level: SLFLogLevel,_ message: LogMessageType) {
        self.log(level, message)
    }
    public func isLoggable(level: SLFLogLevel) -> Bool {
        return (self.level as! SLFLogLevel) <= level
    }
    
    public func doLog(message: LogMessageType) {
        println(message)
    }
    
}