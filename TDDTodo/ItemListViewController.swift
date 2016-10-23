//
//  ItemListViewController.swift
//  TDDTodo
//
//  Created by faiz mokhtar on 20/10/2016.
//  Copyright © 2016 faizmokhtar. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: protocol<UITableViewDataSource, UITableViewDelegate>!

    override func viewDidLoad() {
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }
}
