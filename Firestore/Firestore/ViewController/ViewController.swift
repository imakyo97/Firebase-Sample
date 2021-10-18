//
//  ViewController.swift
//  Firestore
//
//  Created by 今村京平 on 2021/09/10.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet private weak var myTableView: UITableView!

    private var items:[Item] = []

    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()

        print("----\(#function)----")
        let setting = FirestoreSettings()
        Firestore.firestore().settings = setting
        db = Firestore.firestore()

        getCollection()

        myTableView.dataSource = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InputVCSegue" {
            let navigationController = segue.destination as! UINavigationController
            let inputViewController = navigationController.topViewController as! InputViewController
            inputViewController.didSavedItem = { [weak self] in
                guard let self = self else { return }
                self.items.append($0)
                self.myTableView.reloadData()
            }
        }
    }

    private func getCollection() {
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("KakeiboData").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error getting documents: \(error)")
            } else if let documents = querySnapshot?.documents {
                for document in documents {
                    let result = Result {
                        try document.data(as: Item.self)
                    }
                    switch result {
                    case .success(let item):
                        if let item = item { self.items.append(item) }
                    case .failure(let error):
                        print("Error decoding item: \(error)")
                    }
                }
                self.myTableView.reloadData()
            }
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
        cell.configure(item: items[indexPath.row])
        return cell
    }
}

