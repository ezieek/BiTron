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
        let names = ["0x", "Algory", "Augur", "Basic Attention Token", "Bitcoin", "Bitcoin Cash", "Golem"]
        
        while(true) {
            for i in names {
                app.tables.staticTexts[i].tap()
                sleep(2)
                app.navigationBars.buttons.element(boundBy: 0).tap()
                sleep(3)
            }
        }
    }
    
    func testSelectingFavoriteCryptocurrencies() throws {
        let app = XCUIApplication()
        let names = ["0x", "Algory", "AMLT", "Augur", "Basic Attention Token", "Bitcoin", "Bitcoin Cash", "Bitcoin Gold", "Bitcoin SV", "Blockchain Poland", "Bob\'s Repair", "Chainlink", "Dash", "Ethereum", "Experty", "Game Credits", "Golem", "Infinity Economics", "Lisk", "Lisk Machine Learning", "Litecoin", "Maker", "Neumark", "OmniseGO", "Ripple", "Stellar", "TenX", "Tron", "Zcash"]
        
        while(true) {
            for i in 0..<names.count {
                app.tabBars.buttons.element(boundBy: 1).tap()
                sleep(1)
                app.tables.cells.element(boundBy: i).tap()
                sleep(2)
            }
        }
    }
}
