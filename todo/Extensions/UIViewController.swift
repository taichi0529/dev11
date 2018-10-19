//
//  UIViewController.swift
//  todo
//
//  Created by 中村太一 on 2018/10/19.
//  Copyright © 2018 中村太一. All rights reserved.
//

import UIKit
extension UIViewController {
    func alert(_ title: String, _ message: String, _ closedHandler: (()->Void)?) {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            print("閉じる")
            if let closedHandler = closedHandler {
                closedHandler()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
