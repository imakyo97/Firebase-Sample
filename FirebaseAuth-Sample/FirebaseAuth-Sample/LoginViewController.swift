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
        case create((String) -> ()) // 登録
        case fotgotPassword
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
    private var userName: (String) -> () = { _ in }

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
            let login = "ログイン"
            userNameStackView.removeFromSuperview()
            enterButton.setTitle(login, for: .normal)
            enterRightBarButton.title = login
        case .create(let userName):
            let register = "登録"
            forgotPasswordButton.removeFromSuperview()
            enterButton.setTitle(register, for: .normal)
            enterRightBarButton.title = register
            self.userName = userName
        case .fotgotPassword:
            userNameStackView.removeFromSuperview()
            passwordStackView.removeFromSuperview()
            forgotPasswordButton.removeFromSuperview()
            enterButton.setTitle("再設定メールを送信", for: .normal)
            enterRightBarButton.title = "送信"
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
                    self.dismiss(animated: true, completion: nil)
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
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func changeRequestDisplayName(displayName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        print("changeRequest.displayName: \(changeRequest?.displayName)")
        changeRequest?.commitChanges { error in
            if let error = error {
                print("changeRequest.commitChanges-error: \(error.localizedDescription)")
            } else {
                self.userName(self.userNameTextField.text!)
            }
        }
    }

    private func sendPasswordReset() {
        guard let mail = mailTextField.text else { return }
        Auth.auth().sendPasswordReset(withEmail: mail) { error in
            if let error = error {
                print("sendPasswordReset-Error: \(error)")
            } else {
                print("sendPasswordReset-Success")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction private func didTapEnterButton(_ sender: Any) {
        switch mode {
        case .login:
            signIn()
        case .create:
            createUser()
        case .fotgotPassword:
            sendPasswordReset()
        }
    }

    @IBAction func didTapCancelBarButtn(_ sender: Any) {
        switch mode {
        case .login, .create:
            dismiss(animated: true, completion: nil)
        case .fotgotPassword:
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func didTapForgotPasswordButton(_ sender: Any) {
        let loginViewController = LoginViewController.instantiate(mode: .fotgotPassword)
        navigationController?.pushViewController(loginViewController, animated: true)
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
