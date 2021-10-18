//
//  LoginViewController.swift
//  FirebaseUI-Sample
//
//  Created by 今村京平 on 2021/10/18.
//

import UIKit
import FBSDKLoginKit

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
    }

    private func setupMode() {
        switch mode {
        case .login:
            userNameLabel.isHidden = true
            userTextField.isHidden = true
            enterButton.titleLabel?.text = "ログイン"
        case .register:
            enterButton.titleLabel?.text = "登録"
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
