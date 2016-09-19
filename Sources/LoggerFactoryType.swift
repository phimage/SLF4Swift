//
//  LoggerFactoryType.swift
//  SLF4Swift
//
//  Created by phimage on 30/05/15.
//  Copyright (c) 2015-2016 phimage. All rights reserved.
//

import Foundation

public typealias LoggerKeyType = String

/* A factory for logger */
public protocol LoggerFactoryType {
    
    var defaultLogger: LoggerType {get}
    var allLoggers: [LoggerType] {get}
    
    // TODO replace String by Hashable or Printable key?
    func getLogger(_ name: LoggerKeyType) -> LoggerType?
    func createLogger(_ name: LoggerKeyType) -> LoggerType
    func removeLogger(_ name: LoggerKeyType) -> LoggerType?
    func removeAllLoggers()
    
}

/* Factory with only one logger */
open class SingleLoggerFactory: LoggerFactoryType {
    
    open var defaultLogger: LoggerType
    
    public init(logger: LoggerType) {
        self.defaultLogger = logger
    }

    open var allLoggers: [LoggerType] {
        return [defaultLogger]
    }
    
    open func getLogger(_ name: LoggerKeyType) -> LoggerType? {
        return defaultLogger
    }
    open func createLogger(_ name: LoggerKeyType) -> LoggerType {
        return defaultLogger
    }
    open func removeLogger(_ name: LoggerKeyType) -> LoggerType? {
        return nil
    }
    open func removeAllLoggers() {
        // nothing
    }
}


/* A proxy pattern usefull to use an already implemented factory
 * and return a different logger according to key
 * ex: return a NullLogger.instance for specific framework key
 */
open class ProxyLoggerFactory: LoggerFactoryType {
    
    var factory: LoggerFactoryType
    
    open lazy var defaultLogger: LoggerType = self.factory.defaultLogger
    
    public init(factory: LoggerFactoryType) {
        self.factory = factory
    }
    
    open var allLoggers: [LoggerType] {
        return factory.allLoggers
    }
    
    open func getLogger(_ name: LoggerKeyType) -> LoggerType? {
        return factory.getLogger(name)
    }
    
    open func createLogger(_ name: LoggerKeyType) -> LoggerType {
        return factory.createLogger(name)
    }
    
    open func removeLogger(_ name: LoggerKeyType) -> LoggerType? {
        return factory.removeLogger(name)
    }
    
    open func removeAllLoggers() {
        self.factory.removeAllLoggers()
    }
}


/* Factory for SLFLogger, with logger name as key
 * doCreateLogger could be overriden to change logger type
 */
open class SLFLoggerFactory: LoggerFactoryType {

    open static var sharedInstance = SLFLoggerFactory()

    fileprivate var loggers = Dictionary<LoggerKeyType,LoggerType>()

    public init(){
    }

    // Default level when create a new logger
    open var defaultLevel: SLFLogLevel = SLFLoggerFactory.getDefaultLevel() {
        didSet {
            if mustUpdateAllLoggersLevel {
                updateAllLoggersLevel(defaultLevel)
            }
        }
    }
    
    // when modifying factory log level, update all logger levels
    open var mustUpdateAllLoggersLevel = false
    
    open func updateAllLoggersLevel(_ level: SLFLogLevel) {
        for logger in allLoggers {
            if let slfLogger = logger as? SLFLogger {
                slfLogger.level = defaultLevel
            }
        }
    }
    
    fileprivate static func getDefaultLevel() -> SLFLogLevel {
        #if DEBUG
            return  SLFLogLevel.Verbose
            #else
            return SLFLogLevel.info
        #endif
    }
    
    // root logger
    open lazy var defaultLogger: LoggerType = self.doCreateLogger("root")
    
    open var allLoggers: [LoggerType] {
        return Array<LoggerType>(loggers.values)
    }
    
    open func getLogger(_ name: LoggerKeyType) -> LoggerType? {
        return loggers[name]
    }

    open func createLogger(_ name: LoggerKeyType) -> LoggerType {
        if let logger = loggers[name] {
            return logger
        }
        let newLogger = self.doCreateLogger(name)
        addLogger(newLogger)
        return newLogger
    }
    
    open func addLogger(_ logger: LoggerType) {
        loggers[logger.name] = logger
    }

    open func removeLogger(_ name: LoggerKeyType) -> LoggerType? {
        return loggers.removeValue(forKey: name)
    }

    open func removeAllLoggers() {
        self.loggers.removeAll(keepingCapacity: false)
    }
    
    open func doCreateLogger(_ name: LoggerKeyType) -> LoggerType {
        return SLFLogger(level: defaultLevel, name: name)
    }

}
