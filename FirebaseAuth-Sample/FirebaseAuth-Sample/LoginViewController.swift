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

    // MARK: - init
    init?(coder: NSCoder, mode: Mode) {
        self.mode = mode
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("💣LoginViewController - deinit")
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
        case .create:
            let register = "登録"
            forgotPasswordButton.removeFromSuperview()
            enterButton.setTitle(register, for: .normal)
            enterRightBarButton.title = register
        case .fotgotPassword:
            userNameStackView.removeFromSuperview()
            passwordStackView.removeFromSuperview()
            forgotPasswordButton.removeFromSuperview()
            enterButton.setTitle("再設定メールを送信", for: .normal)
            enterRightBarButton.title = "送信"
        }
    }

    // MARK: - viewDidLayoutSubviews()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topImageView.layer.cornerRadius = topImageView.bounds.height * 0.15
        topImageView.layer.masksToBounds = true
    }

    typealias ResultHandler<T> = (Result<T, Error>) -> ()

    private func createUser(resultHandler: @escaping ResultHandler<Void>) {
        guard userNameTextField.text != "" else { return }
        guard mailTextField.text != "" else { return }
        guard passwordTextField.text != "" else { return }
        // メールアドレスとパスワードを渡して、新しいアカウントを作成
        Auth.auth().createUser(withEmail: mailTextField.text!,
                               password: passwordTextField.text!) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            // アカウント作成に失敗
            if let error = error {
                resultHandler(.failure(error))
                return
            }

            // アカウント作成に成功
            guard let authResult = authResult else { return }

            // ユーザー名の設定
            let changeRequest = authResult.user.createProfileChangeRequest()
            changeRequest.displayName = strongSelf.userNameTextField.text!
            changeRequest.commitChanges { error in
                // ユーザー名の設定に失敗
                if let error = error {
                    resultHandler(.failure(error))
                    return
                }

                // ユーザー名の設定に成功
                // 確認メールの送信
                authResult.user.sendEmailVerification{ error in
                    if let error = error {
                        // 確認メール送信失敗
                        resultHandler(.failure(error))
                    } else {
                        // 確認メール送信成功
                        resultHandler(.success(()))
                    }
                }
            }
        }
    }

    private func signIn(resultHandler: @escaping ResultHandler<Void>) {
        guard mailTextField.text != "" else { return }
        guard passwordTextField.text != "" else { return }
        // メールアドレスとパスワードを渡して、ログイン
        Auth.auth().signIn(withEmail: mailTextField.text!,
                           password: passwordTextField.text!) { authResult, error in
            if let error = error {
                // ログインに失敗
                resultHandler(.failure(error))
            } else {
                // ログインに成功
                resultHandler(.success(()))
            }
        }
    }

    private func sendPasswordReset(resultHandler: @escaping ResultHandler<Void>) {
        guard let mail = mailTextField.text else { return }
        Auth.auth().sendPasswordReset(withEmail: mail) { error in
            if let error = error {
                // 再設定メールの送信に失敗
                resultHandler(.failure(error))
            } else {
                // 再設定メールの送信に成功
                resultHandler(.success(()))
            }
        }
    }

    private func presentErrorAlertView(alertTitle: String?, message: String?) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func presentSuccessAlertView(alertTitle: String?, message: String?, transition: Transition?) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                guard let strongSelf = self else { return }
                guard let transition = transition else { return }
                switch transition {
                case .dismiss:
                    strongSelf.dismiss(animated: true, completion: nil)
                case .popViewController:
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            })
        )
        present(alert, animated: true, completion: nil)
    }

    @IBAction private func didTapEnterButton(_ sender: Any) {
        switch mode {
        case .login:
            signIn() { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success():
                    strongSelf.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    let errorCode = AuthErrorCode(rawValue: error._code)
                    guard let errorCode = errorCode else { return }
                    switch errorCode {
                    case .invalidEmail:
                        // メールアドレスの形式が正しくないことを示します。
                        strongSelf.presentErrorAlertView(alertTitle: "メールアドレスの形式が正しくありません。",
                                                         message: "メールアドレスを正しく入力してください。")
                    case .userDisabled:
                        // ユーザーのアカウントが無効になっていることを示します。
                        strongSelf.presentErrorAlertView(alertTitle: "無効なアカウントです。",
                                                         message: "他のアカウントでログインしてください。")
                    case .wrongPassword:
                        // ユーザーが間違ったパスワードでログインしようとしたことを示します。
                        strongSelf.presentErrorAlertView(alertTitle: "パスワードが一致しません。",
                                                         message: "パスワードを正しく入力してください。")
                    case .userNotFound:
                        // ユーザーアカウントが見つからなかったことを示します。
                        strongSelf.presentErrorAlertView(alertTitle: "アカウントが見つかりません。",
                                                         message: "アカウントを新規作成してください。")
                    case .tooManyRequests:
                        // 呼び出し元の端末から Firebase Authentication サーバーに異常な数のリクエストが行われた後で、リクエストがブロックされたことを示します。
                        strongSelf.presentErrorAlertView(alertTitle: "アカウント登録に失敗しました。",
                                         message: "しばらくしてからもう一度お試しください。")
                    default:
                        strongSelf.presentErrorAlertView(alertTitle: "ログインに失敗しました。",
                                         message: error.localizedDescription)
                    }
                }
            }
        case .create:
            createUser() { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success():
                    strongSelf.presentSuccessAlertView(alertTitle: "確認メールを送信しました。",
                                                 message: "確認メールが届いていない場合、メールアドレスの変更が必要です。",
                                                       transition: .dismiss)
                case .failure(let error):
                    Auth.auth().currentUser?.delete(completion: { error in
                        if let error = error {
                            print("- Error - User.delete(comletion:): \(error)")
                        }
                    })
                    let errorCode = AuthErrorCode(rawValue: error._code)
                    guard let errorCode = errorCode else { return }
                    switch errorCode {
                    case .emailAlreadyInUse:
                        // 登録に使用されたメールアドレスがすでに存在することを示します。
                        strongSelf.presentErrorAlertView(alertTitle: "登録済みのメールアドレスです。",
                                         message: "ログイン画面からログインしてください。")
                    case .invalidEmail:
                        // メールアドレスの形式が正しくないことを示します。
                        strongSelf.presentErrorAlertView(alertTitle: "メールアドレスの形式が正しくありません。",
                                         message: "メールアドレスを正しく入力してください。")
                    case .tooManyRequests:
                        // 呼び出し元の端末から Firebase Authentication サーバーに異常な数のリクエストが行われた後で、リクエストがブロックされたことを示します。
                        strongSelf.presentErrorAlertView(alertTitle: "アカウント登録に失敗しました。",
                                         message: "しばらくしてからもう一度お試しください。")
                    case .weakPassword:
                        // 設定しようとしたパスワードが弱すぎると判断されたことを示します。
                        strongSelf.presentErrorAlertView(alertTitle: "パスワードが脆弱です。",
                                         message: "第三者から判定されづらいパスワードにしてください")
                    default:
                        strongSelf.presentErrorAlertView(alertTitle: "アカウント登録に失敗しました。",
                                         message: error.localizedDescription)
                    }
                }
            }
        case .fotgotPassword:
            sendPasswordReset() { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success():
                    strongSelf.presentSuccessAlertView(alertTitle: "再設定メールを送信しました。",
                                            message: "メールを確認し、パスワードの再設定を行ってください。",
                                            transition: .popViewController)
                case .failure(let error):
                    let errorCode = AuthErrorCode(rawValue: error._code)
                    guard let errorCode = errorCode else { return }
                    switch errorCode {
                    case .userNotFound:
                        // ユーザーアカウントが見つからなかったことを示します。
                        strongSelf.presentErrorAlertView(alertTitle: "アカウントが見つかりません。",
                                                         message: "メールアドレスを正しく入力してください。")
                    case .tooManyRequests:
                        // 呼び出し元の端末から Firebase Authentication サーバーに異常な数のリクエストが行われた後で、リクエストがブロックされたことを示します。
                        strongSelf.presentErrorAlertView(alertTitle: "再設定メールの送信に失敗しました。",
                                         message: "しばらくしてからもう一度お試しください。")
                    case .invalidEmail:
                        // メールアドレスの形式が正しくないことを示します。
                        strongSelf.presentErrorAlertView(alertTitle: "メールアドレスの形式が正しくありません。",
                                         message: "メールアドレスを正しく入力してください。")
                    default:
                        strongSelf.presentErrorAlertView(alertTitle: "再設定メールの送信に失敗しました。",
                                         message: error.localizedDescription)
                    }
                }
            }
        }
    }

    @IBAction private func didTapCancelBarButtn(_ sender: Any) {
        switch mode {
        case .login, .create:
            dismiss(animated: true, completion: nil)
        case .fotgotPassword:
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction private func didTapForgotPasswordButton(_ sender: Any) {
        let loginViewController = LoginViewController.instantiate(mode: .fotgotPassword)
        navigationController?.pushViewController(loginViewController, animated: true)
    }

    private let eyeImage = UIImage(systemName: "eye")
    private let eyeSlashImage = UIImage(systemName: "eye.slash")
    @IBAction private func didTapSecureTextButton(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry {
            // 入力内容を非表示
            sender.setImage(eyeImage, for: .normal)
        } else {
            // 入力内容を表示
            sender.setImage(eyeSlashImage, for: .normal)
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

extension LoginViewController {
    enum Transition {
        case dismiss
        case popViewController
    }
}
