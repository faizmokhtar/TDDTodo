//
//  KeychainAccessible.swift
//  TDDTodo
//
//  Created by Faiz Mokhtar on 22/12/2016.
//  Copyright © 2016 faizmokhtar. All rights reserved.
//

import Foundation

protocol KeychainAccessible {
    func setPassword(password: String, account: String)
    
    func deletePasswordForAccount(account: String)
    
    func passwordForAccount(account: String) -> String?
}