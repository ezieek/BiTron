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
    
    func testAddingFavoriteCryptocurrencies() throws {
        let app = XCUIApplication()
        let tabBarButton = app.tabBars.buttons.element(boundBy: 1)
        let tableViewCell = app.tables.cells

        for number in 0..<29 {
            tabBarButton.tap()
            sleep(1)
            tableViewCell.element(boundBy: number).tap()
            sleep(2)
        }
    }
    
    func testDeletingFavoriteCryptocurrencies() throws {
        let app = XCUIApplication()
        let firstTableViewCell = app.tables.cells.element(boundBy: 0)
        let navBarButtonItem = app.navigationBars.buttons.element(boundBy: 1)
        
        for _ in 0..<29 {
            firstTableViewCell.tap()
            sleep(2)
            navBarButtonItem.tap()
            sleep(2)
        }
    }
}
