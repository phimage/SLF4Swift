//
//  SystemLogger.swift
//  SLF4Swift
/*
The MIT License (MIT)

Copyright (c) 2015-2016 Eric Marchand (phimage)

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

open class SystemLogger: SLFLogger {
    open static let LINE_DELIMITER = "\n"
    
    fileprivate static let stdout = FileHandle.standardOutput
    fileprivate static let stderr = FileHandle.standardError
    
    override open func doLog(_ level: SLFLogLevel,_ message: LogMessageType) {
        if level.isIssues() {
            SystemLogger.errorln(message)
        } else {
            SystemLogger.println(message)
        }
    }
    
    open class func errorln(_ message: LogMessageType) {
        writeTo(stderr, message + SystemLogger.LINE_DELIMITER)
    }
    open class func println(_ message: LogMessageType) {
        writeTo(stdout, message + SystemLogger.LINE_DELIMITER)
    }
    
    open class func writeTo(_ handle: FileHandle, _ string: String) {
        if let data = string.data(using: String.Encoding.utf8) {
            handle.write(data)
        }
    }
}
