//
//  ItemListDataProvider.swift
//  TDDTodo
//
//  Created by faiz mokhtar on 20/10/2016.
//  Copyright © 2016 faizmokhtar. All rights reserved.
//

import UIKit

enum Section: Int {
    case ToDo
    case Done
}

class ItemListDataProvider: NSObject, UITableViewDataSource {

    var itemManager: ItemManager?

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let itemManager = itemManager else { return 0 }
        guard let itemSection = Section(rawValue: section) else {
            fatalError()
        }

        let numberOfRows: Int
        switch itemSection {
        case .ToDo:
            numberOfRows = itemManager.toDoCount ?? 0
        case .Done:
            numberOfRows = itemManager.doneCount ?? 0
        }
        return numberOfRows
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell

        guard let itemManager = itemManager else { fatalError() }
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }

        let item: ToDoItem
        switch section {
        case .ToDo:
            item = itemManager.itemAtIndex(indexPath.row)
        case .Done:
            item = itemManager.doneItemAtIndex(indexPath.row)
        }

        cell.configCellWithItem(item)
        return cell
    }
}
