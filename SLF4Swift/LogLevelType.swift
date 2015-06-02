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

/* level to filter message */
internal protocol LogLevelType {
    /* integer to compare log level */
    var level: Int {get}
    /* name of level, used to print level if necessarry */
    var name: String {get}
}

public enum SLFLogLevel: Int, LogLevelType, Equatable, Comparable, Printable {
    case Off, Severe, Error, Warn, Info, Debug, Verbose, All
    
    public static var levels: [SLFLogLevel] {return [Off, Severe, Error, Warn, Info, Debug, Verbose, All]}
    public static var config: [SLFLogLevel] {return [Off, All]}
    public static var issues: [SLFLogLevel] {return [Severe, Error, Warn]}
    
    public var level: Int {
        return rawValue
    }
    
    public var name: String {
        switch(self) {
        case Off: return "Off"
        case Severe: return "Severe" // Critical, Fatal
        case Error: return "Error"
        case Warn: return "Warn"
        case Info: return "Info"
        case Debug: return "Debug"
        case Verbose: return "Verbose" // Trace
        case All: return "All"
        }
    }

    public var description : String { return self.name }
    public var shortDescription : String {
        let d = self.description
        return String(d[d.startIndex])
    }
    
    public func isIssues() -> Bool {
        return contains(SLFLogLevel.issues, self)
    }
    public func isConfig() -> Bool {
        return contains(SLFLogLevel.config, self)
    }
    public func isFlag() -> Bool {
        return !isConfig()
    }
    
}
public func ==(lhs: SLFLogLevel, rhs: SLFLogLevel) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
public func <(lhs: SLFLogLevel, rhs: SLFLogLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}
