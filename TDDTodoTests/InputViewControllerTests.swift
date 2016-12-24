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
        let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.dateTextField.text = "02/22/2016"
        mockInputViewController.locationTextField.text = "Office"
        mockInputViewController.addressTextField.text = "Infinite Loop 1, Cupertino"
        mockInputViewController.descriptionTextField.text = "Test Description"
        
        let mockGeocoder = MockGeoCoder()
        mockInputViewController.geocoder = mockGeocoder
        mockInputViewController.itemManager = ItemManager()
        
        let expectation = expectationWithDescription("bla")
        
        mockInputViewController.completionHandler = {
            expectation.fulfill()
        }
        mockInputViewController.save()
        
        placemark = MockPlaceMark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        waitForExpectationsWithTimeout(1, handler: nil)
        
        let item = mockInputViewController.itemManager?.itemAtIndex(0)
        
        let testItem = ToDoItem(title: "Test Title",
                                itemDescription: "Test Description",
                                timestamp: 1456070400,
                                location: Location(name: "Office", coordinate: coordinate))
        print("\(item?.title) = \(testItem.title)")
        print("\(item?.itemDescription) = \(testItem.itemDescription)")
        print("\(item?.timestamp) = \(testItem.timestamp)")
        print("\(item?.location) = \(testItem.location)")

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
    
    func test_GeocoderWorkAsExpected() {
        let expectation = expectationWithDescription("Wait for geocode")
        
        CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertino") { (placemarks, error) -> Void in
            let placemark = placemarks?.first
            
            let coordinate = placemark?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }
            
            XCTAssertEqualWithAccuracy(latitude, 37.3316941, accuracy: 0.000001)
            XCTAssertEqualWithAccuracy(longitude, -122.030127, accuracy: 0.000001)
            
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testSave_DismissesViewController() {
            let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.save()
        XCTAssertTrue(mockInputViewController.dismissGotCalled)
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
    
    class MockInputViewController: InputViewController {
        var dismissGotCalled = false
        var completionHandler: (() -> Void)?
        override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
            dismissGotCalled = true
            completionHandler?()
        }
    }
}