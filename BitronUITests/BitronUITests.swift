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
        let names = ["0x", "Algory", "AMLT", "Augur", "Basic Attention Token", "Bitcoin", "Bitcoin Cash", "Bitcoin Gold", "Bitcoin SV", "Blockchain Poland", "Bob\'s Repair", "Chainlink", "Dash", "Ethereum", "Experty", "Game Credits", "Golem", "Infinity Economics", "Lisk", "Lisk Machine Learning", "Litecoin", "Maker", "Neumark", "OmniseGO", "Ripple", "Stellar", "TenX", "Tron", "Zcash"]
        
        while(true) {
            for i in names {
                app.tables.staticTexts[i].tap()
                sleep(2)
                app.navigationBars.buttons.element(boundBy: 0).tap()
                sleep(3)
            }
        }
    }
    
    func testAddingFavoriteCryptocurrencies() throws {
        let app = XCUIApplication()
        let tabButton = app.tabBars.buttons.element(boundBy: 1)
        let myTable = app.tables.cells

        for i in 0..<29 {
            tabButton.tap()
            sleep(1)
            myTable.element(boundBy: i).tap()
            sleep(2)
        }
    }
    
    func testDeletingFavoriteCryptocurrencies() throws {
        let app = XCUIApplication()
        let mainTable = app.tables.cells.element(boundBy: 0)
        let navButton = app.navigationBars.buttons.element(boundBy: 0)
        
        for _ in 0..<29 {
            mainTable.tap()
            sleep(2)
            navButton.tap()
            sleep(2)
        }
    }
}
