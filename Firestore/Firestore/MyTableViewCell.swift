//
//  MyTableViewCell.swift
//  Firestore
//
//  Created by 今村京平 on 2021/09/10.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var intLabel: UILabel!

    func configure(item: Item) {
        nameLabel.text = item.name
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "YYYY年MM月dd日"
        dateLabel.text = dateFormatter.string(from: item.date)
        var value:Int = 0
        switch item.value {
        case .plus(let plus):
            value = plus
        case .minus(let minus):
            value = -minus
        }
        intLabel.text = String(value)
    }
}
