//
//  ItemListDataProviderTests.swift
//  TDDTodo
//
//  Created by faiz mokhtar on 22/10/2016.
//  Copyright © 2016 faizmokhtar. All rights reserved.
//

import XCTest
@testable import TDDTodo

class ItemListDataProviderTests: XCTestCase {

    var controller: ItemListViewController!
    var sut: ItemListDataProvider!
    var tableView: UITableView!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ItemListDataProvider()
        sut.itemManager = ItemManager()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewControllerWithIdentifier("ItemListViewController") as! ItemListViewController

        _ = controller.view

        tableView = controller.tableView
        tableView.delegate = sut
        tableView.dataSource = sut
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        sut.itemManager?.removeAllItems()
        sut.itemManager = nil
    }

    func testNumberOfSections_IsTwo() {
        let numberOfSections = tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 2)
    }

    func testNumberRowsInFirstSection_IsToDoCount() {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        XCTAssertEqual(tableView.numberOfRowsInSection(0), 1)
        sut.itemManager?.addItem(ToDoItem(title: "Second"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRowsInSection(0), 2)
    }

    func testNumberRowsInSecondSection_IsDoneCount() {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        sut.itemManager?.addItem(ToDoItem(title: "Second"))
        sut.itemManager?.checkItemAtIndex(0)
        XCTAssertEqual(tableView.numberOfRowsInSection(1), 1)
        sut.itemManager?.checkItemAtIndex(0)
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRowsInSection(1), 2)
    }

    func testCellForRow_ReturnsItemCell() {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        tableView.reloadData()
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertTrue(cell is ItemCell)
    }

    func testCellForRow_DequeuesCell() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(sut)
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        mockTableView.reloadData()
        _ = mockTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertTrue(mockTableView.cellGotDequeued)
    }

    func testConfigCell_GetsCalledInCellForRow() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(sut)
        let toDoItem = ToDoItem(title: "First", itemDescription: "First Description")
        sut.itemManager?.addItem(toDoItem)
        mockTableView.reloadData()
        let cell = mockTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! MockItemCell
        XCTAssertEqual(cell.toDoItem, toDoItem)
    }

    func testCellInSectionTwo_GetsConfiguredWithDoneItem() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(sut)
        let firstItem = ToDoItem(title: "First", itemDescription: "First description")
        sut.itemManager?.addItem(firstItem)

        let secondItem = ToDoItem(title: "Second", itemDescription: "Second description")
        sut.itemManager?.addItem(secondItem)

        sut.itemManager?.checkItemAtIndex(1)
        mockTableView.reloadData()

        let cell = mockTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! MockItemCell
        XCTAssertEqual(cell.toDoItem, secondItem)
    }

    func testDeletionButtonInFirstSection_ShowsTitleCheck() {
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertEqual(deleteButtonTitle, "Check")
    }

    func testDeletionButtonInFirstSection_ShowsTitleUncheck() {
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
        XCTAssertEqual(deleteButtonTitle, "Uncheck")
    }

    func testCheckingAnItem_ChecksItInTheItemManager() {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        tableView.dataSource?.tableView?(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        XCTAssertEqual(sut.itemManager?.toDoCount, 0)
        XCTAssertEqual(sut.itemManager?.doneCount, 1)
        XCTAssertEqual(tableView.numberOfRowsInSection(0), 0)
        XCTAssertEqual(tableView.numberOfRowsInSection(1), 1)
    }

    func testUncheckingAnItem_UnchecksItInTheItemManager() {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        sut.itemManager?.checkItemAtIndex(0)
        tableView.reloadData()
        tableView.dataSource?.tableView?(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
        XCTAssertEqual(sut.itemManager?.toDoCount, 1)
        XCTAssertEqual(sut.itemManager?.doneCount, 0)
        XCTAssertEqual(tableView.numberOfRowsInSection(0), 1)
        XCTAssertEqual(tableView.numberOfRowsInSection(1), 0)
    }
    
    func testSelectingCell_SendsNotification() {
        let item = ToDoItem(title: "First")
        sut.itemManager?.addItem(item)
        
        expectationForNotification("ItemSelectedNotification", object: nil) { (notification) -> Bool in
            guard let index = notification.userInfo?["index"] as? Int else {
                return false
            }
            return index == 0
        }
        
        tableView.delegate?.tableView!(tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        waitForExpectationsWithTimeout(3, handler: nil)
    }
}

extension ItemListDataProviderTests {
    class MockTableView: UITableView {
        var cellGotDequeued = false

        override func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            cellGotDequeued = true

            return super.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        }

        class func mockTableViewWithDataSource(dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .Plain)
            mockTableView.dataSource = dataSource
            mockTableView.registerClass(MockItemCell.self, forCellReuseIdentifier: "ItemCell")

            return mockTableView
        }
    }

    class MockItemCell: ItemCell {
        var toDoItem: ToDoItem?

        override func configCellWithItem(item: ToDoItem, checked: Bool = false) {
            toDoItem = item
        }
    }
}
