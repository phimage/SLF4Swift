//
//  SLF4Swift.swift
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

/* register a shared LoggerFactoryType to install a logger system */
public class SLF4Swift {

    public class func initialize() {
        // set default factory according to preprocessor macros
        #if NULL_LOGGER
        SLF4Swift.setSharedFactory(NullLoggerFactory.instance)
        #else
        SLF4Swift.setSharedFactory(SimpleLoggerFactory.sharedInstance)
        #endif
    }

    private static var _sharedFactory: AnyObject? = nil

    public class func setSharedFactory<T: LoggerFactoryType>(factory: T) {
        _sharedFactory = factory as? AnyObject
    }
    
    public class func getSharedFactory<T: LoggerFactoryType>() -> T {
        if _sharedFactory == nil {
            initialize()
        }
       return _sharedFactory as! T
    }

    public class func defaultLogger<F: LoggerFactoryType, T:LoggerType where T == F.T>() -> T {
        let factory: F = SLF4Swift.getSharedFactory()
        return factory.defaultLogger
    }
    public class func getLogger<F: LoggerFactoryType, T:LoggerType where T == F.T>(name: String) -> T? {
        let factory: F = SLF4Swift.getSharedFactory()
        return factory.getLogger(name)
    }
    public class func createLogger<F: LoggerFactoryType, T:LoggerType where T == F.T>(name: String) -> T? {
        let factory: F = SLF4Swift.getSharedFactory()
        return factory.createLogger(name)
    }
}

/*public func SLFLogInfo<F: LoggerFactoryType, T:LoggerType where T == F.T>(message: String){
    let logger: T = SLF4Swift.defaultLogger()
    logger.info(message)
}
public func SLFLogError(message: String){
    SLF4Swift.defaultLogger().error(message)
}
public func SLFLogSevere(message: String){
    SLF4Swift.defaultLogger().severe(message)
}
public func SLFLogWarn(message: String){
    SLF4Swift.defaultLogger().warn(message)
}
public func SLFLogDebug(message: String){
    SLF4Swift.defaultLogger().debug(message)
}
public func SLFLogVerbose(message: String){
    SLF4Swift.defaultLogger().verbose(message)
}
public func SLFLog<T: LogLevelType>(level: T, message: String){
    SLF4Swift.defaultLogger().log(level, message: message)
}*/
