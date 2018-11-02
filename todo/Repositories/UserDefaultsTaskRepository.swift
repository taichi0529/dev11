//
//  UserDefaultTaskRepository.swift
//  todo
//
//  Created by 中村太一 on 2018/11/02.
//  Copyright © 2018 中村太一. All rights reserved.
//

import Foundation

class UserDefaultTaskRepository: TaskRepositoryProtocol {
    let userDefaults = UserDefaults.standard
    
    func save(_ tasks: [Task]) {
        // シリアル化
        do {
            let data = try PropertyListEncoder().encode(tasks)
            // UserDefaultsにtasksという名前で保存
            userDefaults.set(data, forKey: "tasks")
        } catch {
            fatalError ("Save Faild.")
        }
    }
    
    func load() -> [Task] {
        if let data = userDefaults.data(forKey: "tasks") {
            do {
                let tasks = try PropertyListDecoder().decode([Task].self, from: data)
                return tasks
            } catch {
                fatalError ("Cannot Load.")
            }
        }
        return []
    }
}
