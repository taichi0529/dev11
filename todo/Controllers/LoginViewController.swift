//
//  LoginViewController.swift
//  todo
//
//  Created by 中村太一 on 2018/10/19.
//  Copyright © 2018 中村太一. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTouchNewButton(_ sender: Any) {
        if let credential = getCredential() {
            Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (result, error) in
                if let error = error {
                    print (error.localizedDescription)
                    self.alert("エラー", error.localizedDescription, nil)
                    return
                }
                print ("ユーザー作成成功")
                self.presentTaskList()
                
            }
        }
    }
    
    @IBAction func didTouchLoginButton(_ sender: Any) {
        if let credential = getCredential() {
            Auth.auth().signIn(withEmail: credential.email, password: credential.password) { (result, error) in
                if let error = error {
                    print (error.localizedDescription)
                    self.alert("エラー", error.localizedDescription, nil)
                    return
                }
                print ("ログイン成功")
                self.presentTaskList()
                
            }
        }
    }
    
    func getCredential() -> Credential?{
        let email = emailTextField.text!
        let password = passwordTextField.text!
        if (email.isEmpty) {
            self.alert("エラー", "メールアドレスを入力して下さい", nil)
            return nil
        }
        if (password.isEmpty) {
            self.alert("エラー", "パスワードを入力して下さい", nil)
            return nil
        }
        return Credential(email: email, password: password)
    }
    
    func presentTaskList () {
        //Storyboardを指定
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "TaskNavigationController")
        self.present(viewController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
