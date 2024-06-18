//
//  ViewController.swift
//  TodoListApp
//
//  Created by mac on 15/06/24.
//

import UIKit
import RealmSwift


class ViewController: UIViewController {
    
    // MARK:- Properties
    var todoViewModel = TodoViewModel()
    var todoListArray = [Todo]()
    var isGetAllTodoCalled = true
    
    // MARK:- Outlets
    @IBOutlet weak var todoListTableView: UITableView!
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if todoListArray.count < 30 {
            self.todoViewModel.getAllTodo { [weak self] in
                self?.todoListTableView.reloadData()
                self?.configuration()
            }
        }
    }
    
    // MARK:- Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertViewController = UIAlertController(title: "Add Todo", message: "Please add your Todo details", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            if let todo = alertViewController.textFields?.first?.text {
                let todoList = Todo(todo: todo)
                self.todoListArray.append(todoList)
                LocalManager.shared.saveContext(todo: todoList)
                self.todoViewModel.postTodo(title: todo)
                self.todoListTableView.reloadData()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertViewController.addTextField { todoListTextField in
            todoListTextField.placeholder = "Enter your todo details"
        }
        alertViewController.addAction(save)
        alertViewController.addAction(cancel)
        present(alertViewController, animated: true)
    }
}
extension ViewController{
    
    // MARK:- TableView Configurations
    func configuration(){
        todoListTableView.dataSource = self
        todoListTableView.delegate = self
        todoListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        todoListArray = LocalManager.shared.getTodoList()
        print(todoListArray)
    }
    
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = todoListArray[indexPath.row].todo
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            let alertViewController = UIAlertController(title: "Update Todo", message: "Please update your Todo details", preferredStyle: .alert)
            let save = UIAlertAction(title: "Save", style: .default) { _ in
                if let todo = alertViewController.textFields?.first?.text {
                    let todoList = Todo(todo: todo)
                    LocalManager.shared.updateTodoList(existingValue: self.todoListArray[indexPath.row], NewValue: todoList)
                    self.todoListTableView.reloadData()
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertViewController.addTextField { todoListTextField in
                todoListTextField.text = self.todoListArray[indexPath.row].todo
            }
            alertViewController.addAction(save)
            alertViewController.addAction(cancel)
            self.present(alertViewController, animated: true)
        }
        edit.backgroundColor = .systemMint
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            LocalManager.shared.deleteTodoList(todo: self.todoListArray[indexPath.row])
            self.todoListArray.remove(at: indexPath.row)
            self.todoListTableView.reloadData()
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipeConfiguration
    }
}
