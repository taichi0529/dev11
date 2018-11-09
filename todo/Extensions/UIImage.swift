//
//  UIImage.swift
//  todo
//
//  Created by 中村太一 on 2018/11/10.
//  Copyright © 2018 中村太一. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio > heightRatio ? widthRatio : heightRatio
        let resizedSize = CGSize(width: ceil(size.width * ratio), height: ceil(size.height * ratio))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
}
