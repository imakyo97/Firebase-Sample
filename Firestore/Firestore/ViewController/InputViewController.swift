//
//  InputViewController.swift
//  Firestore
//
//  Created by 今村京平 on 2021/09/10.
//

import UIKit

class InputViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var valueTextField: UITextField!
    @IBOutlet private weak var myDatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextField.inputView = myDatePicker
    }

    @IBAction private func didTapSaveButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func dateTextFieldValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "YYYY年MM月dd日"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
}
