//
//  Channel.swift
//  Vmedia
//
//  Created by kandavel on 18/03/23.
//

import Foundation
struct Channel: Codable {
    var orderNum, accessNum: Int?
    var callSign: String?
    var id: Int?

    enum CodingKeys: String, CodingKey {
        case orderNum, accessNum
        case callSign = "CallSign"
        case id
    }
}
