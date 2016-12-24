//
//  TDDTodoUITests.swift
//  TDDTodoUITests
//
//  Created by Faiz Mokhtar on 24/12/2016.
//  Copyright © 2016 faizmokhtar. All rights reserved.
//

import XCTest

class TDDTodoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        
        app.navigationBars["TDDTodo.ItemListView"].buttons["Add"].tap()
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("Hello world")
        
        let dateTextField = app.textFields["Date"]
        dateTextField.tap()
        app.textFields["Date"].typeText("02/22/2016")
        
        let locationNameTextField = app.textFields["Location Name"]
        locationNameTextField.tap()
        app.textFields["Location Name"].typeText("Bangi")
        
        let addressTextField = app.textFields["Address"]
        addressTextField.tap()
        app.textFields["Address"].typeText("Seksyen 15")
        
        let descriptionTextField = app.textFields["Description"]
        descriptionTextField.tap()
        app.textFields["Description"].typeText("Testing UI Test")
        app.buttons["Save"].tap()
        
        XCTAssertTrue(app.tables.staticTexts["Hello world"].exists)
        XCTAssertTrue(app.tables.staticTexts["02/22/2016"].exists)
        XCTAssertTrue(app.tables.staticTexts["Bangi"].exists)

        
    }
    
}
