import UIKit
import FirebaseAuth

if let errorCode = AuthErrorCode(rawValue: error._code) {
    switch errorCode {
    case .operationNotAllowed:
        // メールアドレスとパスワードを使用するアカウントが有効になっていないことを示します。
        // Firebase コンソールの [Authentication] セクションで有効にしてください。
    case .emailAlreadyInUse:
        // 登録に使用されたメールアドレスがすでに存在することを示します。
        /* fetchProvidersForEmail を呼び出してそのユーザーが使用したログイン方法を確認し、
         そのいずれかの方法を使用してログインするようユーザーに求めてください。*/
    case .invalidEmail:
        // メールアドレスの形式が正しくないことを示します。
    case .tooManyRequests:
        // 呼び出し元の端末から Firebase Authentication サーバーに異常な数のリクエストが行われた後で、リクエストがブロックされたことを示します。
        // しばらくしてからもう一度お試しください。
    case .weakPassword:
        // 設定しようとしたパスワードが弱すぎると判断されたことを示します。
        // NSError.userInfo 辞書オブジェクトの NSLocalizedFailureReasonErrorKey フィールドに、ユーザーに表示できる詳細な説明が含まれています。
    default:
        <#code#>
    }
}

enum DatabaseError: Error {
case entryNotFound
case duplicatedEntry
case invalidEntry(reason: String)
}

struct User {
    let id: Int
    let name: String
    let email: String
}

func findUser(byID id: Int, complition: (Result<User, DatabaseError>) -> ()) {
    let users = [
        User(id: 1, name: "annpannmann", email: "annpanpi"),
        User(id: 2, name: "syokupanman", email: "syokupanpi")
    ]

    for user in users {
        if user.id == id {
            complition(.success(user))
            print("💣")
        }
    }

    complition(.failure(.entryNotFound))
}

let id = 1
let result = findUser(byID: id) { result in
    switch result {
    case let .success(user):
        print("user\(user)")
    case let .failure(error):
        switch error {
        case .entryNotFound:
            print("entryNotFound")
        case .duplicatedEntry:
            print("duplicateEntry")
        case .invalidEntry:
            print("invalidEntry")
        }
    }
}


