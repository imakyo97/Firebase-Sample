//
//  LoginViewController.swift
//  FirebaseUI-Sample
//
//  Created by 今村京平 on 2021/10/18.
//

import UIKit

final class LoginViewController: UIViewController {

    enum Mode {
        case login
        case register // 登録
    }

    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userTextField: UITextField!
    @IBOutlet private weak var mailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
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
        setupMode()
    }

    private func setupMode() {
        switch mode {
        case .login:
            userNameLabel.removeFromSuperview()
            userTextField.removeFromSuperview()
            enterButton.setTitle("ログイン", for: .normal)
        case .register:
            enterButton.setTitle("登録", for: .normal)
        }
    }

    @IBAction private func didTapCancelBarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func didTapSaveButton(_ sender: Any) {
    }

    @IBAction private func didTapEnterButton(_ sender: Any) {
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
