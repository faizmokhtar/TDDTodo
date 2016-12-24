//
//  ToDoItemTests.swift
//  TDDTodo
//
//  Created by faiz mokhtar on 17/10/2016.
//  Copyright © 2016 faizmokhtar. All rights reserved.
//

import XCTest
@testable import TDDTodo

class ToDoItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit_ShouldSetTitle() {
        let item = ToDoItem(title: "Test title")
        XCTAssertEqual(item.title, "Test title", "Initializer should set the item title")
    }

    func testInit_ShouldSetTitleAndDescription() {
        let item = ToDoItem(title: "Test title", itemDescription: "Test description")
        XCTAssertEqual(item.itemDescription, "Test description", "Initializer should set the item description")
    }

    func testInit_ShouldSetTitleAndDescriptionAndTimestamp() {
        let item = ToDoItem(title: "Test title", itemDescription: "Test description", timestamp: 0.0)
        XCTAssertEqual(0.0, item.timestamp, "Initializer should set the timestamp")
    }

    func testInit_ShouldSetTitleAndDescriptionAndTimestampAndLocation() {
        let location = Location(name: "Test name")
        let item = ToDoItem(title: "Test title", itemDescription: "Test description", timestamp: 0.0, location: location)
        XCTAssertEqual(location.name, item.location?.name, "Initializer should set the location")
    }

    func testEqualItems_ShouldBeEqual() {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "First")
        XCTAssertEqual(firstItem, secondItem)
    }

    func testWhenLocationDifferes_ShouldNotBeEqual() {
        let firstItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0, location: Location(name: "Home"))
        let secondItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0, location: Location(name: "Office"))
        XCTAssertNotEqual(firstItem, secondItem)
    }

    func testWhenOneLocationIsNilAndTheOtherIsnt_ShouldNotBeEqual() {
        var firstItem = ToDoItem(title: "First item", itemDescription: "First description", timestamp: 0.0, location: nil)
        var secondItem = ToDoItem(title: "First item", itemDescription: "First description", timestamp: 0.0, location: Location(name: "Office"))
        XCTAssertNotEqual(firstItem, secondItem)
        firstItem = ToDoItem(title: "First item", itemDescription: "First description", timestamp: 0.0, location: Location(name: "Home"))
        secondItem = ToDoItem(title: "First item", itemDescription: "First description", timestamp: 0.0, location: nil)
        XCTAssertNotEqual(firstItem, secondItem)
    }

    func testWhenTimestampDiffers_ShouldNotBeEqual() {
        let firstItem = ToDoItem(title: "First item", itemDescription: "First description", timestamp: 1.0, location: nil)
        let secondItem = ToDoItem(title: "First item", itemDescription: "First description", timestamp: 0.0, location: nil)
        XCTAssertNotEqual(firstItem, secondItem)
    }

    func testWhenDescriptionDiffers_ShouldNotBeEqual() {
        let firstItem = ToDoItem(title: "First item", itemDescription: "First description")
        let secondItem = ToDoItem(title: "First item", itemDescription: "Second description")
        XCTAssertNotEqual(firstItem, secondItem)
    }

    func testWhenTitleDiffers_ShouldNotBeEqual() {
        let firstItem = ToDoItem(title: "First item")
        let secondItem = ToDoItem(title: "Second item")
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func test_HasPlistDictionaryProperty() {
        let item = ToDoItem(title: "First")
        let dictionary = item.plistDict
        
        XCTAssertNotNil(dictionary)
        XCTAssertTrue(dictionary is NSDictionary)
    }
    
    func test_CanBeCreatedFromPlistDictionary() {
        let location = Location(name: "Home")
        let item = ToDoItem(title: "The Title",
                            itemDescription: "The Description",
                            timestamp: 1.0,
                            location: location)
        let dict = item.plistDict
        let recreatedItem = ToDoItem(dict: dict)
        
        XCTAssertEqual(item, recreatedItem)
    }
}
