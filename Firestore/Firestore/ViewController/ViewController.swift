//
//  ViewController.swift
//  Firestore
//
//  Created by 今村京平 on 2021/09/10.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet private weak var myTableView: UITableView!

    private let items:[Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
        cell.configure(item: items[indexPath.row])
        return cell
    }
}

