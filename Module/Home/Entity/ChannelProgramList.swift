//
//  ChannelProgramList.swift
//  Vmedia
//
//  Created by kandavel on 20/03/23.
//

import Foundation
struct ChannelProgramList {
    var channelName : String?
    var channelId : Int?
    var channelOrderNum : Int?
    var programList : [Program] = []
}
struct Program {
    var name : String?
    var startTime : String?
    var startTimeDate: Date?
    var length : Int?
    var programId : Int?
}
