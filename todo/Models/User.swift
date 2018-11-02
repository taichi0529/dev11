//
//  User.swift
//  todo
//
//  Created by 中村太一 on 2018/10/19.
//  Copyright © 2018 中村太一. All rights reserved.
//

import Foundation
import Firebase

protocol UserDelegate: class {
    func didCreate(error: Error?)
    func didLogin(error: Error?)
}

class User {
    
    // シングルトン実装
    static let shared = User()
    
    /*
    private var user: FirebaseAuth.User? = Auth.auth().currentUser
    としてしまうとこのクラスが読み込まれたときに`Auth.auth().currentUser`が実行されてしまい、
    その時点ではAppDelegateのapplicationDidFinishLaunchingWithOptionsが実行されていない?のでエラーになる。
    なのでlazyが必要。コメントアウト下みたいにgetでもOK
    */
//    private var user: FirebaseAuth.User? {
//        get {
//            return Auth.auth().currentUser
//        }
//    }
    lazy private var user: FirebaseAuth.User? = Auth.auth().currentUser
    
    
    weak var delegate: UserDelegate?
    
    private init() {
    }
    
    func create (credential: Credential) {
        Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (result, error) in
            if let error = error {
                print (error.localizedDescription)
            } else {
                print ("ユーザー作成成功")
            }
            self.delegate?.didCreate(error: error)
        }
    }
    
    func login (credential: Credential) {
        Auth.auth().signIn(withEmail: credential.email, password: credential.password) { (result, error) in
            if let error = error {
                print (error.localizedDescription)
            } else {
                print ("ログイン成功")
            }
            self.delegate?.didLogin(error: error)
        }
    }
    
    func logout () {
        try! Auth.auth().signOut()
        print (isLogin())
    }
    
    func isLogin () -> Bool {
        if user != nil {
            return true
        }
        return false
    }
    
    func getUid () -> String? {
        return user?.uid
    }
    
}
