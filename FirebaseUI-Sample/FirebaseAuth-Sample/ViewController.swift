//
//  ViewController.swift
//  FirebaseUI-Sample
//
//  Created by 今村京平 on 2021/10/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func didTapLoginButton(_ sender: Any) {
        let loginViewController = LoginViewController.instantiate(mode: .login)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        present(navigationController, animated: true, completion: nil)
    }

    @IBAction private func didTapSignUpButton(_ sender: Any) {
        let loginViewController = LoginViewController.instantiate(mode: .register)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

