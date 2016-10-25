//
//  InputViewControllerTests.swift
//  TDDTodo
//
//  Created by faiz mokhtar on 25/10/2016.
//  Copyright © 2016 faizmokhtar. All rights reserved.
//

import XCTest
import CoreLocation

@testable import TDDTodo

class InputViewControllerTests: XCTestCase {
    var sut: InputViewController!
    var placemark: MockPlaceMark!
    lazy var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewControllerWithIdentifier("InputViewController") as! InputViewController
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_HasTitleTextField() {
        XCTAssertNotNil(sut.titleTextField)
    }

    func test_HasDateTextField() {
        XCTAssertNotNil(sut.dateTextField)
    }

    func test_HasLocationTextField() {
        XCTAssertNotNil(sut.locationTextField)
    }

    func test_HasAddressTextField() {
        XCTAssertNotNil(sut.addressTextField)
    }

    func test_HasDescriptionTextField() {
        XCTAssertNotNil(sut.descriptionTextField)
    }

    func test_HasSaveButton() {
        XCTAssertNotNil(sut.saveButton)
    }

    func test_HasCancelButton() {
        XCTAssertNotNil(sut.cancelButton)
    }

    func testSave_UsesGeocoderToGetCoordinateFromAddress() {
        sut.titleTextField.text = "Test Title"
        sut.dateTextField.text = "02/22/2016"
        sut.locationTextField.text = "Office"
        sut.addressTextField.text = "Infinite Loop 1, Cupertino"
        sut.descriptionTextField.text = "Test Description"

        let mockGeocoder = MockGeoCoder()
        sut.geocoder = mockGeocoder
        sut.itemManager = ItemManager()
        sut.save()

        placemark = MockPlaceMark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)

        let item = sut.itemManager?.itemAtIndex(0)
        let testItem = ToDoItem(title: "Test Title", itemDescription: "Test Description", timestamp: 1456070400, location: Location(name: "Office", coordinate: coordinate))
        XCTAssertEqual(item, testItem)
    }

    func testSave_OnlyTitle() {
        sut.titleTextField.text = "Test Title"

        sut.itemManager = ItemManager()
        sut.save()

        let item = sut.itemManager?.itemAtIndex(0)
        let testItem = ToDoItem(title: "Test Title")
        XCTAssertEqual(item, testItem)
    }

    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton

        guard let actions = saveButton.actionsForTarget(sut, forControlEvent: .TouchUpInside) else {
            XCTFail(); return
        }
        XCTAssertTrue(actions.contains("save"))
    }
}

extension InputViewControllerTests {
    class MockGeoCoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?

        override func geocodeAddressString(addressString: String, completionHandler: CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }

    class MockPlaceMark: CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?

        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else {
                return CLLocation()
            }
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}