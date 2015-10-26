//
//  XCGLogger.swift
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
import SLF4Swift
import XCGLogger

public class XCGLoggerSLF: LoggerType {
    
    public class var instance : XCGLoggerSLF {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : XCGLoggerSLF?
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = XCGLoggerSLF(logger: XCGLogger.defaultInstance())
        }
        return Static.instance!
    }

    public var level: SLFLogLevel {
        get {
            return XCGLoggerSLF.toLevel(self.logger.outputLogLevel)
        }
        set {
            self.logger.outputLogLevel = XCGLoggerSLF.fromLevel(newValue)
        }
    }
    public var name: LoggerKeyType {
        return self.logger.identifier
    }

    public var logger: XCGLogger
    
    public init(logger: XCGLogger) {
        self.logger = logger
    }

    public func info(message: LogMessageType) {
        self.logger.info(message)
    }
    public func error(message: LogMessageType) {
        self.logger.error(message)
    }
    public func severe(message: LogMessageType) {
        self.logger.severe(message)
    }
    public func warn(message: LogMessageType) {
        self.logger.warning(message)
    }
    public func debug(message: LogMessageType) {
        self.logger.debug(message)
    }
    public func verbose(message: LogMessageType) {
        self.logger.verbose(message)
    }

    public func log(level: SLFLogLevel,_ message: LogMessageType) {
        self.logger.logln(XCGLoggerSLF.fromLevel(level), closure: {message})
    }

    public func isLoggable(level: SLFLogLevel) -> Bool {
        return level <= self.level
    }

    public static func toLevel(level:XCGLogger.LogLevel) -> SLFLogLevel {
        switch(level){
        case .None: return SLFLogLevel.Off
        case .Severe: return SLFLogLevel.Severe
        case .Error: return SLFLogLevel.Error
        case .Warning: return SLFLogLevel.Warn
        case .Info: return SLFLogLevel.Info
        case .Debug: return SLFLogLevel.Debug
        case .Verbose: return SLFLogLevel.Verbose
        }
    }
 
    
    public static func fromLevel(level:SLFLogLevel) -> XCGLogger.LogLevel {
        switch(level){
        case .Off: return XCGLogger.LogLevel.None
        case .Severe: return XCGLogger.LogLevel.Error
        case .Error: return XCGLogger.LogLevel.Error
        case .Warn: return XCGLogger.LogLevel.Warning
        case .Info: return XCGLogger.LogLevel.Info
        case .Debug: return XCGLogger.LogLevel.Debug
        case .Verbose: return XCGLogger.LogLevel.Verbose
        case .All: return XCGLogger.LogLevel.Verbose
        }
    }
    
}

public class XCGLoggerSLFFactory: SLFLoggerFactory {
    
    public class var instance : XCGLoggerSLFFactory {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : XCGLoggerSLFFactory?
        }
        
        dispatch_once(&Static.onceToken) {
            let factory = XCGLoggerSLFFactory()
            Static.instance = factory
            factory.addLogger(XCGLoggerSLF.instance)
        }
        return Static.instance!
    }

    public override init(){
        super.init()
    }
    
    public override func doCreateLogger(name: LoggerKeyType) -> LoggerType {
        let logger = XCGLogger()
        logger.identifier = name
        return  XCGLoggerSLF(logger: logger)
    }
}