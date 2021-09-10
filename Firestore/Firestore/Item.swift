//
//  Item.swift
//  Firestore
//
//  Created by 今村京平 on 2021/09/10.
//

import Foundation

struct Item {
    let name: String
    let date: Date
    let value: PlusMinus
}

enum PlusMinus {
    case plus(Int)
    case minus(Int)
}
