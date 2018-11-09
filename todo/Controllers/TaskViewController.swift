//
//  AddViewController.swift
//  todo
//
//  Created by 中村太一 on 2018/09/22.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit
import GoogleMaps

class TaskViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let taskService = TaskService.shared

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
    
    var didChangeImage = false
    
    @IBOutlet weak var todoImageView: UIImageView!
    
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
        
        var targetTask = Task()
        if let selectedTask = self.selectedTask {
            targetTask = selectedTask
        } else {
            taskService.addTask(targetTask)
        }
        
        targetTask.title = title
        targetTask.note = noteTextView.text
        targetTask.latitude = marker.position.latitude
        targetTask.longitude = marker.position.longitude
        taskService.save()
        self.didChangeImage = false
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
    
    // カメラかアルバムを表示
    func presentPicker (souceType souceType:UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(souceType) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = souceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        } else {
            print ("The SouceType is not found.")
        }
    }
    
    
    
    @IBAction func didTouchTodoImageView(_ sender: Any) {
        // アクションシートを表示
        let alert = UIAlertController(title:"", message: "選択してください", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "カメラ", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            print("カメラ")
            self.presentPicker(souceType: .camera)
            
        }))
        alert.addAction(UIAlertAction(title: "アルバム", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            print("アルバム")
            self.presentPicker(souceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセル")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //　撮影もしくは画像を選択したら呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.todoImageView.contentMode = .scaleAspectFit
            self.todoImageView.image = pickedImage.resize(size: CGSize(width: 300, height: 300))
            self.didChangeImage = true
        }
        
        //閉じる処理
        picker.dismiss(animated: true, completion: nil)
        
    }


}
