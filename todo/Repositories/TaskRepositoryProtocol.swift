//
//  TaskRepositoryProtocol.swift
//  todo
//
//  Created by 中村太一 on 2018/11/02.
//  Copyright © 2018 中村太一. All rights reserved.
//

import Foundation

protocol TaskRepositoryProtocol:class {
    func save(_ tasks: [Task], completion: (()->Void)?)
    func load(completion: (([Task])->Void)?)
}
