//
//  ViewController.swift
//  FirestoreDocument-Sample
//
//  Created by 今村京平 on 2021/09/11.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {

    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()

        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()

    }

    // データを追加
    // usersコレクションにデータを追加
    private func addAdaLavelace() {
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { error in
            if let error = error {
                print("Error adding \(error)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }

    // データを追加
    // usersコレクションにデータを追加
    // 上記のデータ追加と違って"middle": "Mathison"が含まれている
    // コレクション内のドキュメントに、はそれぞれ異なる情報のセットを含ませることができる。
    private func addAlanTuring() {
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Alan",
            "middle": "Mathison",
            "last": "Turing",
            "born": 1912
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }

    // データを読み取る
    private func getCollection() {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
}

