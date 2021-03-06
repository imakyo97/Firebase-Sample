//
//  ViewController.swift
//  FirebaseUI-Sample
//
//  Created by 今村京平 on 2021/10/18.
//

import UIKit
import FirebaseAuth

final class ViewController: UIViewController {

    @IBOutlet private weak var accountView: UIView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var entryButton: UIButton!

    private var handle: AuthStateDidChangeListenerHandle?
    private var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "アカウント"
        setupCornerRadius()
    }

    private func setupCornerRadius() {
        accountView.layer.cornerRadius = accountView.bounds.height / 2
        entryButton.layer.cornerRadius = entryButton.bounds.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 認証状態をリッスン
        // ログイン状態が変わるたびに呼ばれる
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let strongSelf = self else { return }
            strongSelf.currentUser = auth.currentUser
            print("💣user.uid: \(user?.uid)")
            print("💣user.displayName: \(user?.displayName)")
            if user == nil {
                strongSelf.userNameLabel.text = "ログアウト中"
                strongSelf.entryButton.setTitle("ログイン", for: .normal)
            } else {
                strongSelf.entryButton.setTitle("ログアウト", for: .normal)
                if let userName = user?.displayName {
                    strongSelf.userNameLabel.text = userName
                } else {
                    strongSelf.userNameLabel.text = "未設定"
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // リスナーをデタッチ
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    @IBAction func didTapEntryButton(_ sender: Any) {
        if currentUser == nil {
            let loginViewController = LoginViewController.instantiate(mode: .login)
            let navigationController = UINavigationController(rootViewController: loginViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        } else {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    }

    @IBAction private func didTapSignUpButton(_ sender: Any) {
        let loginViewController = LoginViewController.instantiate(mode: .create)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

