//
//  ItemManager.swift
//  TDDTodo
//
//  Created by faiz mokhtar on 18/10/2016.
//  Copyright © 2016 faizmokhtar. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ItemManagerSettable {
    var itemManager: ItemManager? { get set }
}

class ItemManager: NSObject {
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }
    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()
    
    var toDoPathURL: NSURL {
        let fileURLs = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        guard let documentURL = fileURLs.first else {
            print("Something went wrong. Documents url could not be found")
            fatalError()
        }
        return documentURL.URLByAppendingPathComponent("toDoItems.plist")
    }
    
    override init() {
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: "save",
                                                         name: UIApplicationWillResignActiveNotification,
                                                         object: nil)
        
        if let nsToDoItems = NSArray(contentsOfURL: toDoPathURL) {
            for dict in nsToDoItems {
                if let toDoItem = ToDoItem(dict: dict as! NSDictionary) {
                    toDoItems.append(toDoItem)
                }
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        save()
    }

    func addItem(item: ToDoItem) {
        if !toDoItems.contains(item) {
            toDoItems.append(item)
        }
    }

    func itemAtIndex(index: Int) -> ToDoItem {
        return toDoItems[index]
    }

    func doneItemAtIndex(index: Int) -> ToDoItem {
        return doneItems[index]
    }

    func checkItemAtIndex(index: Int) {
        let item = toDoItems.removeAtIndex(index)
        doneItems.append(item)
    }

    func uncheckItemAtIndex(index: Int) {
        let item = doneItems.removeAtIndex(index)
        toDoItems.append(item)
    }

    func removeAllItems() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }
    
    func save() {
        var nsTodoItems = [AnyObject]()
        
        for item in toDoItems {
            nsTodoItems.append(item.plistDict)
        }
        
        if nsTodoItems.count > 0 {
            (nsTodoItems as NSArray).writeToURL(toDoPathURL, atomically: true)
        } else {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(toDoPathURL)
            } catch {
                print(error)
            }
        }
    }
}