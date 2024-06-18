//
//  TodoViewModel.swift
//  TodoListApp
//
//  Created by mac on 16/06/24.
//

import Foundation

class TodoViewModel {
    
    var todoListArray = [Todo]()
    
    private var networking: TodoNetworkClass
    init(networking: TodoNetworkClass) {
        self.networking = networking
    }
    
    func getAllTodo(completion: @escaping () -> Void){
        if LocalManager.shared.getTodoList().count < 30 {
            networking.getAllTodo {
                completion()
            }
        } else {
            completion()
        }
    }
    func postTodo(title: String) {
        let todoList = Todo(todo: title)
        todoListArray.append(todoList)
        LocalManager.shared.saveContext(todo: todoList)
    }
    func saveTodoList() {
        
        todoListArray = LocalManager.shared.getTodoList()
    }
    
    func upodateTodoList(existingValue: Todo, newValue: String) {
        let todoList = Todo(todo: newValue)
        LocalManager.shared.updateTodoList(existingValue: existingValue, NewValue: todoList)
    }
    
    
    func deleteTodo(todo: Todo, indexPath: Int) {
        LocalManager.shared.deleteTodoList(todo: todo)
        self.todoListArray.remove(at: indexPath)
    }
    subscript(index: Int) ->  Todo {
        return todoListArray[index]
    }
    
}
