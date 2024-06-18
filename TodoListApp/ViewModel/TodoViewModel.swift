//
//  TodoViewModel.swift
//  TodoListApp
//
//  Created by mac on 16/06/24.
//

import Foundation
import Alamofire
import Realm

class TodoViewModel {
    func getOneTodo() {
        AF.request("https://dummyjson.com/todos/5").responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    func postTodo(title: String) {
        let parameters: [String: Any] = [
            "todo": title,
            "completed": false,
            "userId": 5
        ]
        
        AF.request("https://dummyjson.com/todos/add", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Todo successfully added to server: \(value)")
                case .failure(let error):
                    print("Failed to add todo to server: \(error)")
                }
            }
    }
    func getAllTodo(completion: @escaping () -> Void) {
        AF.request("https://dummyjson.com/todos").responseJSON { response in
            switch response.result {
            case .success(let data):
                if let json = data as? [String: Any], let todosArray = json["todos"] as? [[String: Any]] {
                    for todoDict in todosArray {
                        let todo = Todo()
                        todo.todo = todoDict["todo"] as! String
                        LocalManager.shared.saveContext(todo: todo)
                        print(todo)
                    }
                }
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
            
        }
    }
}
