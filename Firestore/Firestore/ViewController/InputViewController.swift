//
//  InputViewController.swift
//  Firestore
//
//  Created by 今村京平 on 2021/09/10.
//

import UIKit
import FirebaseFirestore

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
            let usersRef = db.collection("users").document()
            try usersRef.setData(from: item)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }

    @IBAction private func didTapSaveButton(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        guard let stringDate = dateTextField.text else { return }
        guard let stringValue = valueTextField.text else { return }
        let date = DateUtility.dateFromString(stringDate: stringDate, format: "YYYY年MM月dd日")
        let value = Int(stringValue) ?? 0
        let plusMinus = value >= 0 ? PlusMinus.plus(value) : PlusMinus.minus(value)
        let item = Item(name: name, date: date, value: plusMinus)
        self.didSavedItem(item)
        setDocument(item: item)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func dateTextFieldValueChanged(_ sender: UIDatePicker) {
        dateTextField.text =
            DateUtility.stringFromDate(
                date: sender.date,
                format: "YYYY年MM月dd日"
            )
    }
}
