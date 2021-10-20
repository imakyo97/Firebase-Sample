//
//  LoginViewController.swift
//  FirebaseUI-Sample
//
//  Created by 今村京平 on 2021/10/18.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {

    enum Mode {
        case login
        case create // 登録
    }

    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var userNameStackView: UIStackView!
    @IBOutlet private weak var mailStackView: UIStackView!
    @IBOutlet private weak var passwordStackView: UIStackView!
    @IBOutlet var iconImageViews: [UIImageView]!
    @IBOutlet private weak var enterButton: UIButton!

    private let mode: Mode

    // MARK: - init
    init?(coder: NSCoder, mode: Mode) {
        self.mode = mode
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCornerRadius()
        setupMode()
    }

    private func setupCornerRadius() {
        let contentsStackView: [UIStackView] = [
            userNameStackView,
            mailStackView,
            passwordStackView
        ]
        contentsStackView.forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
            $0.layer.masksToBounds = true
        }
        iconImageViews.forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
            $0.layer.masksToBounds = true
        }

        enterButton.layer.cornerRadius = enterButton.bounds.height / 2
        enterButton.layer.masksToBounds = true
    }

    private func setupMode() {
        switch mode {
        case .login:
            userNameStackView.removeFromSuperview()
            enterButton.setTitle("ログイン", for: .normal)
        case .create:
            enterButton.setTitle("登録", for: .normal)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topImageView.layer.cornerRadius = topImageView.bounds.height * 0.15
        topImageView.layer.masksToBounds = true
    }
//
//    private func createUser() {
//        guard userTextField.text != "" else { return }
//        guard mailTextField.text != "" else { return }
//        guard passwordTextField.text != "" else { return }
//        // メールアドレスとパスワードを渡して、新しいアカウントを作成
//        Auth.auth().createUser(withEmail: mailTextField.text!,
//                               password: passwordTextField.text!) { authResult, error in
//            // アカウント作成に失敗
//            guard let authResult = authResult else {
//                print("createUser()-error: \(error!.localizedDescription)")
//                return
//            }
//            // アカウント作成に成功
//            print("createUser()-success: \(authResult)")
//            self.changeRequestDisplayName(displayName: self.userTextField.text!)
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//
//    private func signIn() {
//        guard mailTextField.text != "" else { return }
//        guard passwordTextField.text != "" else { return }
//        // メールアドレスとパスワードを渡して、ログイン
//        Auth.auth().signIn(withEmail: mailTextField.text!,
//                           password: passwordTextField.text!) { authResult, error in
//            // ログインに失敗
//            guard let authResult = authResult else {
//                print("signIn()-error: \(error!.localizedDescription)")
//                return
//            }
//            // ログインに成功
//            print("signIn()-success: \(authResult)")
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//
//    private func changeRequestDisplayName(displayName: String) {
//        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//        changeRequest?.displayName = displayName
//        print("changeRequest.displayName: \(changeRequest?.displayName)")
//        changeRequest?.commitChanges { error in
//            print("changeRequest.commitChanges-error: \(error?.localizedDescription)")
//        }
//    }
//
//    @IBAction private func didTapCancelBarButton(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    @IBAction private func didTapSaveButton(_ sender: Any) {
//        switch mode {
//        case .login:
//            signIn()
//        case .create:
//            createUser()
//        }
//    }
//
//    @IBAction private func didTapEnterButton(_ sender: Any) {
//        switch mode {
//        case .login:
//            signIn()
//        case .create:
//            createUser()
//        }
//    }
}

extension LoginViewController {
    static func instantiate(mode: Mode) -> LoginViewController {
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyBoard.instantiateInitialViewController { coder in
            LoginViewController(coder: coder, mode: mode)
        }!
        return loginViewController
    }
}
