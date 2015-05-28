//
//  String.swift
//  SLF4Swift
//
//  Created by phimage on 28/05/15.
//  Copyright (c) 2015 phimage. All rights reserved.
//

import Foundation

public class StringLogger: SimpleLogger {

    var value: NSMutableString
    
    public var stringValue: String{
        return value as String
    }
    
    public init(level: SimpleLogLevel, initialValue: String = "") {
        self.value = NSMutableString(string: initialValue)
        super.init(level: level, name: "string")
    }
    
    override public func doLog(message: String) {
       value.appendString(message)
    }
}

