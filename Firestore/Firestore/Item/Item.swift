//
//  Item.swift
//  Firestore
//
//  Created by 今村京平 on 2021/09/10.
//

import Foundation

struct Item: Codable {
    let name: String
    let date: Date
    let value: PlusMinus
}

enum PlusMinus {
    case plus(Int)
    case minus(Int)
}

extension PlusMinus: Codable {
    enum CodingKeys: String, CodingKey {
        case plus
        case minus
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(Int.self, forKey: .plus) {
            self = .plus(value)
        } else if let value = try container.decodeIfPresent(Int.self, forKey: .minus) {
            self = .minus(value)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unknown case"
            ))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .plus(let value):
            try container.encode(value, forKey: .plus)
        case .minus(let value):
            try container.encode(value, forKey: .minus)
        }
    }
}
