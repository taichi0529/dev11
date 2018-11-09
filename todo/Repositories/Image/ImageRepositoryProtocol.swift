//
//  ImageRepositoryProtocol.swift
//  todo
//
//  Created by 中村太一 on 2018/11/10.
//  Copyright © 2018 中村太一. All rights reserved.
//

import Foundation
import UIKit

protocol ImageRepositoryProtocol:class {
    // 画像を保存。全部保存したらcompletionを実行します。
    func save(image: UIImage, completion: ((_ imageUrl: String)->Void))
}
