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
    
    let userDefaults = UserDefaults.standard
    private var tasks: [Task] = []
    
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
        // シリアル化
        do {
            let data = try PropertyListEncoder().encode(tasks)
            // UserDefaultsにtasksという名前で保存
            userDefaults.set(data, forKey: "tasks")
        } catch {
            fatalError ("Save Faild.")
        }
        // デリゲートを使ってフックを作っている。保存したら実行
        delegate?.saved()
    }
    
    func load() {
        if let data = userDefaults.data(forKey: "tasks") {
            do {
                let tasks = try PropertyListDecoder().decode([Task].self, from: data)
                self.tasks = tasks
            } catch {
                fatalError ("Cannot Load.")
            }
        }
    }
    
    
    
}
