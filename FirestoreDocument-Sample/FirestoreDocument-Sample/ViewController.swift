//
//  ViewController.swift
//  FirestoreDocument-Sample
//
//  Created by 今村京平 on 2021/09/11.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController {

    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()

        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()

        //        setDocumentWithCodable()
        serverTimestamp()
        getCollection()
    }

    // データを追加
    // usersコレクションにデータを追加
    private func addAdaLovelace() {
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

    // ドキュメントを設定する
    //単一のドキュメントを作成または上書きするには、set() メソッドを使用します。
    private func setDocument() {
        // Add a new document in collection "cities"
        db.collection("cities").document("LA").setData([
            "name": "Los Angeles",
            "state": "CA",
            "country": "USA"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    // ドキュメントを設定する
    // ドキュメントが存在しない場合は、ドキュメントが新規に作成されます。
    /* ドキュメントが存在する場合、次のように既存のドキュメントにデータを統合するように指定しない限り、
     新しく提供されたデータでコンテンツが上書きされます。*/
    // merge: trueとしない限りデータは上書きされる。
    // mergeを使えば書き換えもできる？
    private func createIfMissing() {
        // Update one field, creating the document if it does not exist.
        db.collection("cities").document("LA").setData([ "capital": true ], merge: true)
    }

    // データ型
    /*Cloud Firestore では、文字列、ブール値、日付、NULL、ネストされた配列、オブジェクトなど、
     さまざまなデータ型をドキュメントに書き込むことができます。
     Cloud Firestore は、コードで使用する数字の種類に関係なく、
     数値を常に double 型として保存します。*/
    private func dataTypes() {
        let docData: [String: Any] = [
            "stringExample": "Hello world!",
            "booleanExample": true,
            "numberExample": 3.14159265,
            "dateExample": Timestamp(date: Date()),
            "arrayExample": [5, true, "hello"],
            "nullExample": NSNull(),
            "objectExample": [
                "a": 5,
                "b": [
                    "nested": "foo"
                ]
            ]
        ]
        db.collection("data").document("one").setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    // カスタムオブジェクト
    private func setDocumentWithCodable() {
        // [START set_document_codable]
        let city = City(name: "Los Angeles",
                        state: "CA",
                        country: "USA",
                        isCapital: false,
                        population: 5000000)

        do {
            try db.collection("cities").document("LA").setData(from: city)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
        // [END set_document_codable]
    }

    // ドキュメントを追加する
    /*set() を使用してドキュメントを作成する場合、作成するドキュメントの ID を指定する必要があります。
     ただし、ドキュメントに有効な ID がなく、Cloud Firestore が
     ID を自動的に生成するように設定したほうが都合のよい場合もあります。
     この設定を行うには、add() を呼び出します。*/
    /*重要: Firebase Realtime Database の push ID と異なり、
     Cloud Firestore で自動生成された ID の並べ替えは自動的に行われません。
     ドキュメントを作成日で並べ替えるには、ドキュメントのフィールドとして
     タイムスタンプを保存する必要があります。*/
    private func addDocument() {
        // Add a new document with a generated id.
        var ref: DocumentReference? = nil
        ref = db.collection("cities").addDocument(data: [
            "name": "Tokyo",
            "country": "Japan"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }

    // ドキュメントを追加する
    /*自動生成された ID を持つドキュメント参照を作成して、
     後で参照を使用するほうが実用的な場合もあります。
     このユースケースでは、doc() を呼び出します*/
    /*.add(...) と .doc().set(...) は完全に同等なので、どちらでも使いやすい方を使うことができます。*/
    private func newDocument() {
        // [START new_document]
        let newCityRef = db.collection("cities").document()

        newCityRef.setData([
            "name": "Some City Name"
        ])
    }

    // ドキュメントを更新する
    /*ドキュメント全体を上書きせずにドキュメントの一部のフィールドを更新するには、
     update() メソッドを使用します。*/
    private func updateDocument() {
        let washingtonRef = db.collection("cities").document("DC")
        // Set the "capital" field of the city 'DC'
        washingtonRef.updateData([
            "capital": true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }

    // ドキュメントを更新する
    /*ドキュメントのフィールドに、サーバーが更新を受信した時刻を追跡する
     サーバーのタイムスタンプを設定できます。*/
    private func serverTimestamp() {
        db.collection("cities").document("LA").updateData([
            "lastUpdated": FieldValue.serverTimestamp(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }

    // ドキュメントを削除する
    // ドキュメントを削除するには、delete() メソッドを使用します。
    private func deleteDocument() {
        db.collection("cities").document("LA").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

    // フィールドを削除する
    /*特定のフィールドをドキュメントから削除するには、
     ドキュメントを更新するときに FieldValue.delete() メソッドを使用します。*/
    private func deleteField() {
        db.collection("cities").document("BJ").updateData([
            "capital": FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}

// カスタムオブジェクト
// import FirebaseFirestoreSwiftをする必要あり
struct City: Codable {

    let name: String
    let state: String?
    let country: String?
    let isCapital: Bool?
    let population: Int64?

    enum CodingKeys: String, CodingKey {
        case name
        case state
        case country
        case isCapital = "capital"
        case population
    }

}
