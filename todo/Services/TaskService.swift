//
//  TaskService.swift
//  todo
//
//  Created by 中村太一 on 2018/09/22.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import Foundation

protocol TaskServiceDelegate:class {
    func saved()
}

class TaskService {
    static var shared = TaskService()
    private var tasks: [Task] = []
    
    // タスクを保存する役割を担っている
    // どこに保存するのかは分離している
    private let taskRepository: TaskRepositoryProtocol = UserDefaultTaskRepository()
    
    weak var delegate: TaskServiceDelegate?
    
    private init() {
        self.load()
    }
    
    func getTask (at: Int) -> Task{
        return tasks[at]
    }
    
    func taskCount () -> Int{
        return tasks.count
    }
    
    // タスクの追加
    func addTask (_ task: Task) {
        tasks.append(task)
        self.save()
    }
    
    // タスクの削除
    func removeTask (at: Int) {
        tasks.remove(at: at)
        self.save()
    }
    
    func editTask () {
        self.save()
    }
    
    func save () {
        taskRepository.save(tasks)
        // デリゲートを使ってフックを作っている。保存したら実行
        delegate?.saved()
    }
    func load() {
        tasks = taskRepository.load()
    }
}
