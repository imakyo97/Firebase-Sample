//
//  ViewController.swift
//  FirebaseUI-Sample1
//
//  Created by 今村京平 on 2021/10/19.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController, FUIAuthDelegate {

    private var authViewController: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAuthViewController()
    }

    private func setupAuthViewController() {
        if let authUI = FUIAuth.defaultAuthUI() {
            let providers: [FUIAuthProvider] = [
                FUIGoogleAuth(authUI: authUI),
                FUIOAuth.appleAuthProvider(),
                FUIOAuth.twitterAuthProvider(),
                FUIEmailAuth()
            ]
            authUI.providers = providers
            authUI.delegate = self
            authViewController = authUI.authViewController()
        }
    }

    @IBAction func didTapLoginButton(_ sender: Any) {
        guard let authViewController = authViewController else { return }
        present(authViewController, animated: true, completion: nil)
    }
}
