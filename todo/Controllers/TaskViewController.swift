//
//  AddViewController.swift
//  todo
//
//  Created by 中村太一 on 2018/09/22.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit
import GoogleMaps

class TaskViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    let taskCollection = TaskCollection.shared

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var mapCanvasView: UIView!
    
    var selectedTask: Task?
    let marker = GMSMarker()
    var locationManager = CLLocationManager()
    var currentLocation:CLLocation? = nil
    var mapView: GMSMapView!
    var zoomLevel: Float = 14.0
    let defaultLatitude = 35.6675497
    let defaultLongitude = 139.7137988
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.marker.position.latitude = self.defaultLatitude
        self.marker.position.longitude = self.defaultLongitude
        
        // 編集だった場合
        if let selectedTask = self.selectedTask {
            self.title = "編集"
            self.titleTextField.text = selectedTask.title
            self.noteTextView.text = selectedTask.note
            if let latitude = selectedTask.latitude, let longitude = selectedTask.longitude {
                self.marker.position.latitude = latitude
                self.marker.position.longitude = longitude
            }
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        self.view.addGestureRecognizer(tapRecognizer)
        
        let camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: zoomLevel)
        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: mapCanvasView.bounds.height)
        self.mapView = GMSMapView.map(withFrame: rect, camera: camera)
        
        // 自分の場所を中心に合わせるボタン
        self.mapView?.settings.myLocationButton = true
        // 自分の場所を表示する
        self.mapView?.isMyLocationEnabled = true
        
        self.mapView?.delegate = self
        
        mapCanvasView.addSubview(self.mapView!)
        // 自分の場所を取得
        // https://dev.classmethod.jp/smartphone/ios-corelocation-swift3/
        //        self.locationManager = CLLocationManager()
        // 更新頻度や精度で消費電力がかわってくる
        // 位置情報の更新をどれ位一時停止出来るかを判断 自動車用、歩行者用等など
        self.locationManager.activityType = .other
        // 精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 更新イベントの生成に必要な、水平方向の最小移動距離（メートル単位）
        self.locationManager.distanceFilter = 50
        // 開始
        self.locationManager.startUpdatingLocation()
        
        self.marker.map = self.mapView
    }
    
    /// マーカー以外をタップしたら
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.marker.position = coordinate
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
            selectedTask.latitude = marker.position.latitude
            selectedTask.longitude = marker.position.longitude
            taskCollection.editTask()
        } else {
            let task = Task(title: title)
            task.note = noteTextView.text
            task.latitude = marker.position.latitude
            task.longitude = marker.position.longitude
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
