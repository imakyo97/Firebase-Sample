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
    @IBOutlet private var iconViews: [UIView]!
    @IBOutlet private weak var enterButton: UIButton!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var mailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var enterRightBarButton: UIBarButtonItem!

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
        iconViews.forEach {
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
            enterRightBarButton.title = "ログイン"
        case .create:
            forgotPasswordButton.removeFromSuperview()
            enterButton.setTitle("登録", for: .normal)
            enterRightBarButton.title = "登録"
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topImageView.layer.cornerRadius = topImageView.bounds.height * 0.15
        topImageView.layer.masksToBounds = true
    }

    private func createUser() {
        guard userNameTextField.text != "" else { return }
        guard mailTextField.text != "" else { return }
        guard passwordTextField.text != "" else { return }
        // メールアドレスとパスワードを渡して、新しいアカウントを作成
        Auth.auth().createUser(withEmail: mailTextField.text!,
                               password: passwordTextField.text!) { authResult, error in
            // アカウント作成に失敗
            if let error = error {
                print("💣createUser()-error: \(error.localizedDescription)")
                return
            }
            // アカウント作成に成功
            print("💣createUser()-success: \(authResult)")
            self.changeRequestDisplayName(displayName: self.userNameTextField.text!)
            // 確認メール送信
            print("💣userEmail: \(authResult?.user.email)")
            authResult?.user.sendEmailVerification{ error in
                if let error = error {
                    // 確認メール送信失敗
                    print("💣error: \(error)")
                } else {
                    // 確認メール送信成功
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    private func signIn() {
        guard mailTextField.text != "" else { return }
        guard passwordTextField.text != "" else { return }
        // メールアドレスとパスワードを渡して、ログイン
        Auth.auth().signIn(withEmail: mailTextField.text!,
                           password: passwordTextField.text!) { authResult, error in
            // ログインに失敗
            if let error = error {
                print("signIn()-error: \(error.localizedDescription)")
                return
            }
            // ログインに成功
            print("signIn()-success: \(authResult)")
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func changeRequestDisplayName(displayName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        print("changeRequest.displayName: \(changeRequest?.displayName)")
        changeRequest?.commitChanges { error in
            print("changeRequest.commitChanges-error: \(error?.localizedDescription)")
        }
    }

    @IBAction private func didTapEnterButton(_ sender: Any) {
        switch mode {
        case .login:
            signIn()
        case .create:
            createUser()
        }
    }
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
