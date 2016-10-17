//
//  Protocole.swift
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

/* level to filter message */
internal protocol LogLevelType {
    /* integer to compare log level */
    var level: Int {get}
    /* name of level, used to print level if necessarry */
    var name: String {get}
}

public enum SLFLogLevel: Int, LogLevelType, Equatable, Comparable, CustomStringConvertible {
    case off, severe, error, warn, info, debug, verbose, all
    
    public static var levels: [SLFLogLevel] {return [off, severe, error, warn, info, debug, verbose, all]}
    public static var config: [SLFLogLevel] {return [off, all]}
    public static var issues: [SLFLogLevel] {return [severe, error, warn]}
    
    public var level: Int {
        return rawValue
    }
    
    public var name: String {
        switch(self) {
        case .off: return "Off"
        case .severe: return "Severe" // Critical, Fatal
        case .error: return "Error"
        case .warn: return "Warn"
        case .info: return "Info"
        case .debug: return "Debug"
        case .verbose: return "Verbose" // Trace
        case .all: return "All"
        }
    }

    public var description : String { return self.name }
    public var shortDescription : String {
        let d = self.description
        return String(d[d.startIndex])
    }
    
    public func isIssues() -> Bool {
        return SLFLogLevel.issues.contains(self)
    }
    public func isConfig() -> Bool {
        return SLFLogLevel.config.contains(self)
    }
    public func isFlag() -> Bool {
        return !isConfig()
    }
    
    public var emoji: String {
        switch(self) {
        case .off: return "💤"
        case .severe: return "💣" // Critical, Fatal
        case .error: return "‼️"
        case .warn: return "⚠️"
        case .info: return "ℹ️"
        case .debug: return "🔹"
        case .verbose: return "🗯" // Trace
        case .all: return "🎉"
        }
    }
}
public func ==(lhs: SLFLogLevel, rhs: SLFLogLevel) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
public func <(lhs: SLFLogLevel, rhs: SLFLogLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}
