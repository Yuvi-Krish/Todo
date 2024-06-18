//
//  LocalManager.swift
//  TodoListApp
//
//  Created by mac on 16/06/24.
//

import Foundation
import RealmSwift

class LocalManager {
    static let shared = LocalManager()
    
    private var realm = try! Realm()
    
    func getDataBaseURL() -> URL? {
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    
    func saveContext(todo: Todo) {
        try! realm.write {
            realm.add(todo)
        }
    }
    func getTodoList() -> [Todo] {
        return Array(realm.objects(Todo.self))
    }
    func updateTodoList(existingValue: Todo, NewValue: Todo) {
        try! realm.write {
            existingValue.todo = NewValue.todo
        }
    }
    func deleteTodoList(todo: Todo) {
        try! realm.write {
            realm.delete(todo)
        }
    }
}
