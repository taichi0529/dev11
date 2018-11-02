//
//  TaskListTableViewController.swift
//  todo
//
//  Created by 中村太一 on 2018/09/22.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController, TaskServiceDelegate {

    
    
    let taskService = TaskService.shared
    let user = User.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        taskService.delegate = self
        
    }
    
    // デリゲート
    func saved() {
        print ("saved")
        self.tableView.reloadData()
    }
    func loaded() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func didTouchAddButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showToAddViewController", sender: nil)
    }
    
    // ログアウト
    @IBAction func didTouchLogoutButton(_ sender: Any) {
        user.logout()
        taskService.reset()
        
        //Storyboardを指定
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        //Viewcontrollerを指定
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //rootViewControllerに入れる
        appDelegate.window?.rootViewController = initialViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskService.taskCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print ("Section: " + String(indexPath.section) + " row:" + String(indexPath.row))
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = taskService.getTask(at: indexPath.row).title

        return cell
    }

    // セルの選択
    override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let taskViewController = storyboard?.instantiateViewController(withIdentifier: "TaskViewController") as! TaskViewController
        taskViewController.selectedTask = taskService.getTask(at: indexPath.row)
        self.navigationController?.pushViewController(taskViewController, animated: true)
        //        performSegue(withIdentifier: "showToTaskViewController", sender: selectedTask)
    }
    
    // スワイプで削除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        taskService.removeTask(at: indexPath.row)
    }

}
