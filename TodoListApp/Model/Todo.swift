//
//  Todo.swift
//  TodoListApp
//
//  Created by mac on 17/06/24.
//

import Foundation
import RealmSwift

class Todo:Object {
    @Persisted var todo: String = ""
    
    convenience init(todo: String){
        self.init()
        self.todo = todo
    }
}
