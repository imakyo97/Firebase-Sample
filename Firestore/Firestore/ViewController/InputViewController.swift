//
//  InputViewController.swift
//  Firestore
//
//  Created by 今村京平 on 2021/09/10.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class InputViewController: UIViewController {

    var didSavedItem: (Item) -> Void = { _ in }

    var db: Firestore!

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var valueTextField: UITextField!
    @IBOutlet private weak var myDatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        let setting = FirestoreSettings()
        Firestore.firestore().settings = setting
        db = Firestore.firestore()

        dateTextField.inputView = myDatePicker
    }

    private func setDocument(item: Item) {
        do {
            let usersRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("KakeiboData").document()
            try usersRef.setData(from: item)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }

    @IBAction private func didTapSaveButton(_ sender: Any) {
        guard nameTextField.text != "" else { return }
        guard dateTextField.text != "" else { return }
        guard valueTextField.text != "" else { return }
        let date = DateUtility.dateFromString(stringDate: dateTextField.text!, format: "YYYY年MM月dd日")
        let value = Int(valueTextField.text!) ?? 0
        let plusMinus = value >= 0 ? PlusMinus.plus(value) : PlusMinus.minus(value)
        let item = Item(name: nameTextField.text!, date: date, value: plusMinus)
        self.didSavedItem(item)
        setDocument(item: item)
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func dateTextFieldValueChanged(_ sender: UIDatePicker) {
        dateTextField.text =
            DateUtility.stringFromDate(
                date: sender.date,
                format: "YYYY年MM月dd日"
            )
    }

    @IBAction private func didTapTestButton(_ sender: Any) {
    }
}
