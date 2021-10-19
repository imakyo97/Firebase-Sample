//
//  ViewController.swift
//  FirebaseUI-Sample
//
//  Created by 今村京平 on 2021/10/18.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!

    private var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 認証状態をリッスン
        // ログイン状態が変わるたびに呼ばれる
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            print("user.uid: \(user?.uid)")
            print("user.displayName: \(user?.displayName)")
            if let displayName = user?.displayName {
                print("💣")
                self.userNameLabel.text = displayName
            } else {
                self.userNameLabel.text = "ログアウト中"
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // リスナーをデタッチ
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    @IBAction private func didTapLoginButton(_ sender: Any) {
        let loginViewController = LoginViewController.instantiate(mode: .login)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    @IBAction private func didTapSignUpButton(_ sender: Any) {
        let loginViewController = LoginViewController.instantiate(mode: .create)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    @IBAction func didTapLogoutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

