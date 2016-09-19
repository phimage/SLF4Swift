//
//  SLF4SwiftTests.swift
//  SLF4SwiftTests
//
//  Created by phimage on 28/05/15.
//  Copyright (c) 2015-2016 phimage. All rights reserved.
//

import XCTest
import SLF4Swift

class SLF4SwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
         SLF4Swift.setSharedFactory(SLFLoggerFactory.sharedInstance)
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
        SLFLog(.info, "SLFLog")
    }
    
    func testDefaultLogger() {
        let logger: LoggerType = SLF4Swift.defaultLogger
        logger.info("info message")
        logger.error("error")
        logger.severe("severe")
        logger.warn("warn")
        logger.debug("debug")
        logger.verbose("verbose")
        logger.log(.info,"log")
    }

    func testLoggerNil() {
        if let _: LoggerType = SLF4Swift.getLogger("nil") {
            XCTFail("logger must be nil")
        }
    }

    func testLoggerCreate() {
        var logger = SLF4Swift.createLogger("test")
        XCTAssertTrue(logger.name == "test", "logger name not equals to key") // only for SLFLogger
        
        if SLF4Swift.getLogger("test") == nil {
            XCTFail("failed to get logger")
        }
        _ = SLF4Swift.getLogger("test")!
        
        //let b: Bool = logger === getLogger
        //XCTAssertTrue(b, "created logger must same as retrieved one")
    
        logger.level = SLFLogLevel.info
        logger.info("info message")
        logger.error("error")
        logger.severe("severe")
        logger.warn("warn")
        logger.debug("debug")
        logger.verbose("verbose")
        logger.log(.info,"log")
    }
    
    func testLogLevelMessage() {
        SLFLogLevel.info.message("SLFLogInfo")
        SLFLogLevel.error.message("SLFLogError")
        SLFLogLevel.severe.message("SLFLogSevere")
        SLFLogLevel.warn.message("SLFLogWarn")
        SLFLogLevel.debug.message("SLFLogDebug")
        SLFLogLevel.verbose.message("SLFLogVerbose")
        
        SLFLogLevel.info.trace()
        SLFLogLevel.info.value(SLF4Swift.getLogger("test"))
        SLFLogLevel.info.value(nil)
    }
    
}
