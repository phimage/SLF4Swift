//
//  LoggerFactoryType.swift
//  SLF4Swift
//
//  Created by phimage on 30/05/15.
//  Copyright (c) 2015 phimage. All rights reserved.
//

import Foundation

public typealias LoggerKeyType = String

/* a factory for logger */
public protocol LoggerFactoryType {
    
    var defaultLogger: LoggerType {get}
    var allLoggers: [LoggerType] {get}
    
    // TODO replace String by Hashable or Printable key?
    func getLogger(name: LoggerKeyType) -> LoggerType?
    func createLogger(name: LoggerKeyType) -> LoggerType
    func removeLogger(name: LoggerKeyType) -> LoggerType?
    func removeAllLoggers()
    
}

// only one logger into factory already created
public class UniqueLoggerFactoryType: LoggerFactoryType {
    
    public var defaultLogger: LoggerType
    
    public init(logger: LoggerType) {
        self.defaultLogger = logger
    }

    public var allLoggers: [LoggerType] {
        return [defaultLogger]
    }
    
    public func getLogger(name: LoggerKeyType) -> LoggerType? {
        return defaultLogger
    }
    public func createLogger(name: LoggerKeyType) -> LoggerType {
        return defaultLogger
    }
    public func removeLogger(name: LoggerKeyType) -> LoggerType? {
        return nil
    }
    public func removeAllLoggers() {
        // nothing
    }
}

// abstract factory, doCreateLogger must be overriden
public class ByKeyLoggerFactory: LoggerFactoryType {
    
    public func doCreateLogger(name: LoggerKeyType) -> LoggerType {
        assert(true, "must be overriden to create logger")
        return NullLogger.instance // Must be overriden
    }

    private var loggers = Dictionary<LoggerKeyType,LoggerType>()
    
    public lazy var defaultLogger: LoggerType = self.doCreateLogger("root")
    
    public var allLoggers: [LoggerType] {
        return Array<LoggerType>(loggers.values)
    }
    
    public func getLogger(name: LoggerKeyType) -> LoggerType? {
        return loggers[name]
    }
    public func createLogger(name: LoggerKeyType) -> LoggerType {
        if let logger = loggers[name] {
            return logger
        }
        let newLogger = self.doCreateLogger(name)
        loggers[name] = newLogger
        return newLogger
    }
    public func removeLogger(name: LoggerKeyType) -> LoggerType? {
        return loggers.removeValueForKey(name)
    }
    public func removeAllLoggers() {
        self.loggers.removeAll(keepCapacity: false)
    }

}

/* Create SLFLogger */
public class SLFLoggerFactory: ByKeyLoggerFactory {
    public class var sharedInstance : SLFLoggerFactory {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : SLFLoggerFactory?
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = SLFLoggerFactory()
        }
        return Static.instance!
    }
    
    public override func doCreateLogger(name: LoggerKeyType) -> LoggerType {
        return SLFLogger(level: SLFLogLevel.Info, name: name)
    }
    
}