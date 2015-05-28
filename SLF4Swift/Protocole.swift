//
//  Protocole.swift
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

/* level for message */
public protocol LogLevelType: Hashable, Comparable {
    var level: Int {get}
    var name: String {get}
    
    static var levels: [Self] {get}
    
    // var isWarnOrError: Bool
}

/* a logger */
public protocol LoggerType {
    
    typealias T: LogLevelType
    
    var name: String {get}
    var level: T {get}
    
    func info(message: String)
    func error(message: String)
    func severe(message: String)
    func warn(message: String)
    func debug(message: String)
    func verbose(message: String)
    func log(level: T,_ message: String)

    func isLoggable(level: T) -> Bool
    
}

/* a factory for logger */
public protocol LoggerFactoryType {
    typealias T: LoggerType
    
    var defaultLogger: T {get}
    var allLoggers: [T] {get}

    // TODO replace String by Hashable or Printable key?
    func getLogger(name: String) -> T?
    func createLogger(name: String) -> T
    func removeLogger(name: String) -> T?
    func removeAllLoggers()
    
}