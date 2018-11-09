//
//  TaskRepositoryProtocol.swift
//  todo
//
//  Created by 中村太一 on 2018/11/02.
//  Copyright © 2018 中村太一. All rights reserved.
//

import Foundation

protocol TaskRepositoryProtocol:class {
    // データを保存・読み込みしたらcompletionを実行します。
    func save(_ tasks: [Task], completion: (()->Void))
    func load(completion: (@escaping ([Task])->Void))
}
