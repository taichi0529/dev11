//
//  AddViewController.swift
//  todo
//
//  Created by 中村太一 on 2018/09/22.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    let taskCollection = TaskCollection.shared

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    var selectedTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedTask = self.selectedTask {
            self.title = "編集"
            self.titleTextField.text = selectedTask.title
            self.noteTextView.text = selectedTask.note
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        self.view.addGestureRecognizer(tapRecognizer)
        
        
    }
    @IBAction func didTouchSaveButton(_ sender: Any) {
        guard let title = titleTextField.text else {
            return
        }
        if (title.isEmpty) {
            showAlert("タイトルを入力して下さい。")
            return
        }

        if let selectedTask = self.selectedTask {
            selectedTask.title = title
            selectedTask.note = noteTextView.text
            taskCollection.editTask()
        } else {
            let task = Task(title: title)
            task.note = noteTextView.text
            taskCollection.addTask(task)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(_ text: String){
        let alertController = UIAlertController(title: "エラー", message: text , preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) -> Void in
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //画面をタップすると、キーボードが閉じる動作
    @objc func tapGesture(sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
