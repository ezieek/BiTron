//
//  BitronUITests.swift
//  BitronUITests
//
//  Created by Maciej Wołejko on 11/24/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import XCTest

class BitronUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().activate()
    }

    override func tearDownWithError() throws {
        // put code here
    }

    func testCheckingApplicationDoesNotCrushWhenCellIsTapped() throws {
        let app = XCUIApplication()
    
        let names = ["Algory", "Augur", "Basic Attention Token", "Bitcoin", "Bob's Repair", "0x", "Chainlink"]
        
        while(true) {
            for i in names {
                app.tables.staticTexts[i].tap()
                sleep(2)
                app.navigationBars.buttons.element(boundBy: 0).tap()
                sleep(3)
            }
        }
    }
}
