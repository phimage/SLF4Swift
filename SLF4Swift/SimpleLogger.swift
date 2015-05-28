//
//  SimpleLogger.swift
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

public enum SimpleLogLevel: Int, LogLevelType {
    case Off, Severe, Error, Warn, Info, Debug, Verbose, All
    
    public var level: Int {
        return rawValue
    }
    
    public var name: String {
        switch(self) {
        case Off: return "Off"
        case Severe: return "Severe"
        case Error: return "Error"
        case Warn: return "Warn"
        case Info: return "Info"
        case Debug: return "Debug"
        case Verbose: return "Verbose"
        case All: return "All"
        }
    }

    public static var levels: [SimpleLogLevel] {return [Off, Severe, Error, Warn, Info, Debug, Verbose, All]}
}
public func ==(lhs: SimpleLogLevel, rhs: SimpleLogLevel) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
public func <(lhs: SimpleLogLevel, rhs: SimpleLogLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

public class SimpleLogger : LoggerType {
    typealias T = SimpleLogLevel
    
    public var level: SimpleLogLevel
    public var name: String
    public var prefixClosure: (() -> String)?
    
    public init(level: SimpleLogLevel, name: String) {
        self.level = level
        self.name = name
    }
    
    public func info(message: String) {
        log(SimpleLogLevel.Info, message)
    }
    public func error(message: String) {
        log(SimpleLogLevel.Error, message)
    }
    public func severe(message: String) {
        log(SimpleLogLevel.Severe, message)
    }
    public func warn(message: String) {
        log(SimpleLogLevel.Warn, message)
    }
    public func debug(message: String) {
        log(SimpleLogLevel.Debug, message)
    }
    public  func verbose(message: String) {
        log(SimpleLogLevel.Verbose, message)
    }
    public func log(level: SimpleLogLevel,_ message: String) {
        if isLoggable(level) {
            if let closure = prefixClosure {
                let prefix = closure()
                doLog("\(prefix)\(message)")
            } else {
                doLog("\(message)")
            }
        }
    }
    public func isLoggable(level: SimpleLogLevel) -> Bool {
        return self.level <= level
    }
    
    public func doLog(message: String) {
        println(message)
    }
    
}

public class SimpleLoggerFactory: LoggerFactoryType {
    typealias T = SimpleLogger
    
    public class var sharedInstance : SimpleLoggerFactory {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : SimpleLoggerFactory?
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = SimpleLoggerFactory()
        }
        return Static.instance!
    }
    
    private var loggers = Dictionary<String,SimpleLogger>()
    
    public var defaultLogger: SimpleLogger = SimpleLogger(level: SimpleLogLevel.Info, name: "root")
    
    public var allLoggers: [SimpleLogger] {
        return Array<SimpleLogger>(loggers.values)
    }
    
    public func getLogger(name: String) -> SimpleLogger? {
        return loggers[name]
    }
    public func createLogger(name: String) -> SimpleLogger {
        return loggers[name] ?? SimpleLogger(level: SimpleLogLevel.Info, name: name)
    }
    public func removeLogger(name: String) -> SimpleLogger? {
        return loggers.removeValueForKey(name)
    }
    public func removeAllLoggers() {
        self.loggers.removeAll(keepCapacity: false)
    }
}