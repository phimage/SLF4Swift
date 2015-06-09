//
//  LoggerFactoryType.swift
//  SLF4Swift
//
//  Created by phimage on 30/05/15.
//  Copyright (c) 2015 phimage. All rights reserved.
//

import Foundation

public typealias LoggerKeyType = String

/* A factory for logger */
public protocol LoggerFactoryType {
    
    var defaultLogger: LoggerType {get}
    var allLoggers: [LoggerType] {get}
    
    // TODO replace String by Hashable or Printable key?
    func getLogger(name: LoggerKeyType) -> LoggerType?
    func createLogger(name: LoggerKeyType) -> LoggerType
    func removeLogger(name: LoggerKeyType) -> LoggerType?
    func removeAllLoggers()
    
}

/* Factory with only one logger */
public class SingleLoggerFactory: LoggerFactoryType {
    
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


/* A proxy pattern usefull to use an already implemented factory
 * and return a different logger according to key
 * ex: return a NullLogger.instance for specific framework key
 */
public class ProxyLoggerFactory: LoggerFactoryType {
    
    var factory: LoggerFactoryType
    
    public lazy var defaultLogger: LoggerType = self.factory.defaultLogger
    
    public init(factory: LoggerFactoryType) {
        self.factory = factory
    }
    
    public var allLoggers: [LoggerType] {
        return factory.allLoggers
    }
    
    public func getLogger(name: LoggerKeyType) -> LoggerType? {
        return factory.getLogger(name)
    }
    
    public func createLogger(name: LoggerKeyType) -> LoggerType {
        return factory.createLogger(name)
    }
    
    public func removeLogger(name: LoggerKeyType) -> LoggerType? {
        return factory.removeLogger(name)
    }
    
    public func removeAllLoggers() {
        self.factory.removeAllLoggers()
    }
}


/* Factory for SLFLogger, with logger name as key
 * doCreateLogger could be overriden to change logger type
 */
public class SLFLoggerFactory: LoggerFactoryType {
    
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

    private var loggers = Dictionary<LoggerKeyType,LoggerType>()

    // Default level when create a new logger
    public var defaultLevel: SLFLogLevel = SLFLoggerFactory.getDefaultLevel() {
        didSet {
            if mustUpdateAllLoggersLevel {
                updateAllLoggersLevel(defaultLevel)
            }
        }
    }
    
    // when modifying factory log level, update all logger levels
    public var mustUpdateAllLoggersLevel = false
    
    public func updateAllLoggersLevel(level: SLFLogLevel) {
        for logger in allLoggers {
            if let slfLogger = logger as? SLFLogger {
                slfLogger.level = defaultLevel
            }
        }
    }
    
    private static func getDefaultLevel() -> SLFLogLevel {
        #if DEBUG
            return  SLFLogLevel.Verbose
            #else
            return SLFLogLevel.Info
        #endif
    }
    
    // root logger
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
    
    public func doCreateLogger(name: LoggerKeyType) -> LoggerType {
        return SLFLogger(level: defaultLevel, name: name)
    }

}
