//
//  ViewController.swift
//  FirebaseUI-Sample
//
//  Created by 今村京平 on 2021/10/18.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var settingTableView: UITableView!

//    private var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "設定"
        setupTableView()
    }

    private func setupTableView() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }

    private let items: [String] = [
        "アカウント"
    ]

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    // MARK: - UIViewControllerDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移を実装
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // 認証状態をリッスン
//        // ログイン状態が変わるたびに呼ばれる
//        handle = Auth.auth().addStateDidChangeListener { auth, user in
//            print("user.uid: \(user?.uid)")
//            print("user.displayName: \(user?.displayName)")
//            if let displayName = user?.displayName {
//                print("💣")
//                self.userNameLabel.text = displayName
//            } else {
//                self.userNameLabel.text = "ログアウト中"
//            }
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        // リスナーをデタッチ
//        Auth.auth().removeStateDidChangeListener(handle!)
//    }
//
//    @IBAction private func didTapLoginButton(_ sender: Any) {
//        let loginViewController = LoginViewController.instantiate(mode: .login)
//        let navigationController = UINavigationController(rootViewController: loginViewController)
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true, completion: nil)
//    }
//
//    @IBAction private func didTapSignUpButton(_ sender: Any) {
//        let loginViewController = LoginViewController.instantiate(mode: .create)
//        let navigationController = UINavigationController(rootViewController: loginViewController)
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true, completion: nil)
//    }
//
//    @IBAction func didTapLogoutButton(_ sender: Any) {
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print("Error signing out: %@", signOutError)
//        }
//    }
}

