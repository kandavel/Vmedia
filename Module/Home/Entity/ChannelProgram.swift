//
//  ChannelProgram.swift
//  Vmedia
//
//  Created by kandavel on 18/03/23.
//

import Foundation

// MARK: - ChannelProgramElement
struct ChannelProgram: Codable {
    var startTime: String?
    var recentAirTime: RecentAirTime?
    var length: Int?
    var name: String?
}

// MARK: - RecentAirTime
struct RecentAirTime: Codable {
    var id, channelID: Int?
}
