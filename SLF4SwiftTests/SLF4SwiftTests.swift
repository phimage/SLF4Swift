//
//  SLF4SwiftTests.swift
//  SLF4SwiftTests
//
//  Created by phimage on 28/05/15.
//  Copyright (c) 2015 phimage. All rights reserved.
//

import UIKit
import XCTest
import SLF4Swift

class SLF4SwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFacade() {
        SLFLogInfo("SLFLogInfo")
        SLFLogError("SLFLogError")
        SLFLogSevere("SLFLogSevere")
        SLFLogWarn("SLFLogWarn")
        SLFLogDebug("SLFLogDebug")
        SLFLogVerbose("SLFLogVerbose")
        SLFLog(.Info, "SLFLog")
    }
    
    func testDefaultLogger() {
        let logger: LoggerType = SLF4Swift.defaultLogger
        logger.info("info message")
        logger.error("error")
        logger.severe("severe")
        logger.warn("warn")
        logger.debug("debug")
        logger.verbose("verbose")
        logger.log(.Info,"log")
    }
    
    
    func testLoggerNil() {
        if let nilLogger: LoggerType = SLF4Swift.getLogger("nil") {
            XCTFail("logger must be nil")
        }
    }
    
    func testLoggerCreate() {
       let logger = SLF4Swift.createLogger("test")
        XCTAssertTrue(logger.name == "test", "logger name not equals")
        
        if SLF4Swift.getLogger("test") == nil {
            XCTFail("failed to get logger")
        }
        let getLogger = SLF4Swift.getLogger("test")!
        
        //let b: Bool = logger === getLogger
        //XCTAssertTrue(b, "created logger must same as retrieved one")
    
        logger.info("info message")
        logger.error("error")
        logger.severe("severe")
        logger.warn("warn")
        logger.debug("debug")
        logger.verbose("verbose")
        logger.log(.Info,"log")

    }
}
