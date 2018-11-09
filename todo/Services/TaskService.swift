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
    func loaded()
}

// 授業ではTaskCollectionという名前でしたが変更しています。
class TaskService {
    static var shared = TaskService()
    private var tasks: [Task] = []
    
    // タスクを保存する役割を担っている
    // どこに保存するのかは分離している
    private var taskRepository: TaskRepositoryProtocol = FirestoreTaskRepository()
    
    weak var delegate: TaskServiceDelegate?
    
    private init() {

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
    }
    
    // タスクフラグを立てる
    func removeTask (at: Int) {
        tasks[at].deleted = true
    }
    
    func reset () {
        tasks = []
    }
    
    func save () {
        taskRepository.save(tasks) {
            // 削除フラグが立っているタスクを消している
            self.tasks = self.tasks.filter { $0.deleted == false }
            // デリゲートを使ってフックを作っている。保存したら実行
            self.delegate?.saved()
        }
    }
    func load() {
        taskRepository.load(completion: { (tasks) in
            self.tasks = tasks
            // デリゲートでフック。読み出したら実行
            self.delegate?.loaded()
        })
    }
}
