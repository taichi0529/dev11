//
//  UserDefaultTaskRepository.swift
//  todo
//
//  Created by 中村太一 on 2018/11/02.
//  Copyright © 2018 中村太一. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirestoreTaskRepository: TaskRepositoryProtocol {

    let db = Firestore.firestore()
    
    init(){
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    // ユーザー毎のデータベースへの参照を取得する
    private func getCollectionRef () -> CollectionReference {
        guard let uid = User.shared.getUid() else {
            fatalError ("Uidを取得出来ませんでした。")
        }
        return db.collection("users").document(uid).collection("tasks")
    }
    
    func save(_ tasks: [Task], completion: (() -> Void)) {
        // TODO トランザクション
        let collectionRef = getCollectionRef()
        tasks.forEach { (task) in
            if let id = task.id {
                let documentRef = collectionRef.document(id)
                documentRef.setData(task.toData())
            } else {
                
                let documentRef = collectionRef.addDocument(data: task.toData())
                task.id = documentRef.documentID
            }
        }
        
        // firestoreへの保存は非同期ではない（後でバックグラウンドで同期をしている？）
        completion()
    }
    
    func load(completion: @escaping (([Task]) -> Void)) {
        print ("データロード")
        var tasks: [Task] = [];
        let collectionRef = getCollectionRef()
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print (error.localizedDescription)
            }else if let documents = querySnapshot?.documents {
                documents.forEach({ (document) in
                    if document.exists {
                        let data = document.data()
                        let task = Task(data: data)
                        tasks.append(task)
                    }
                })
            }
            completion(tasks)
        }

    }
}
