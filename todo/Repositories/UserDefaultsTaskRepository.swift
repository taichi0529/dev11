//
//  UserDefaultTaskRepository.swift
//  todo
//
//  Created by 中村太一 on 2018/11/02.
//  Copyright © 2018 中村太一. All rights reserved.
//

import Foundation

class UserDefaultsTaskRepository: TaskRepositoryProtocol {

    let userDefaults = UserDefaults.standard
    
    func save(_ tasks: [Task], completion: (() -> Void)?) {
        // シリアル化
        do {
            let data = try PropertyListEncoder().encode(tasks)
            // UserDefaultsにtasksという名前で保存
            userDefaults.set(data, forKey: "tasks")
        } catch {
            fatalError ("Save Faild.")
        }
        if let completion = completion {
            completion()
        }
    }
    
    func load(completion: (([Task]) -> Void)?) {
        var tasks: [Task] = [];
        if let data = userDefaults.data(forKey: "tasks") {
            do {
                tasks = try PropertyListDecoder().decode([Task].self, from: data)
            } catch {
                fatalError ("Cannot Load.")
            }
        }
        if let completion = completion {
            completion(tasks)
        }
    }
}
