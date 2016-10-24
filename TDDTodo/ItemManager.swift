//
//  ItemManager.swift
//  TDDTodo
//
//  Created by faiz mokhtar on 18/10/2016.
//  Copyright © 2016 faizmokhtar. All rights reserved.
//

import Foundation

class ItemManager {
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }
    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()

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
}