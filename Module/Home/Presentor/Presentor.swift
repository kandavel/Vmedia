//
//  Presentor.swift
//  Vmedia
//
//  Created by kandavel on 18/03/23.
//

import Foundation

protocol ChannelListPresentorProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var interactor: ChannelListInteractorProtocol? { get set }
    var wireframe: ChannelListProtocol? { get set }
    func viewDidLoad()
    func numberOfColumnCount() -> Int
    func numberOfRowsCount() -> Int
    func getTodaysDateString() -> String
    func getChannelInfo(indexPath : IndexPath) -> ChannelProgramList?
    func getHoursinfo(indexPath : IndexPath) -> String
    func getChannelProgramInfo(indexPath : IndexPath) -> Program?
    func getTitle() -> String
}

class ChannelListPresentor: ChannelListPresentorProtocol {
    
    var view: HomeViewProtocol?
    var interactor: ChannelListInteractorProtocol?
    var wireframe: ChannelListProtocol?
    
    fileprivate var channels: [Channel] = []
    fileprivate var programList : [ChannelProgram] = []
    fileprivate var channelProgramList : [ChannelProgramList] = []
    let dispatchGroup  = DispatchGroup()
    let sempaphore  = DispatchSemaphore(value: 0)
    fileprivate var timeIntervals: [Date] = []
    fileprivate let currentDate = Date()
    
    func viewDidLoad() {
        self.view?.showTitle()
        self.view?.registerNib()
        self.view?.registerCollectionView()
        self.view?.showLoadingView()
        self.view?.hideView()
        DispatchQueue.global(qos: .background).async {
            self.interactor?.fetchChannelListData()
            self.sempaphore.wait()
            self.interactor?.fetchChannelProgramListData()
            self.sempaphore.wait()
            self.setChannelListData()
            DispatchQueue.main.async {
                self.view?.reloadData()
                self.view?.hideLoadingView()
                self.view?.hideView()
            }
        }
    }
    
    func numberOfColumnCount() -> Int {
        if self.channels.isEmpty {
            return 0
        }
        return self.channels.count + 1
    }
    
    func numberOfRowsCount() -> Int {
        if self.timeIntervals.isEmpty {
            return 0
        }
        return self.timeIntervals.count + 1
    }
    
    func getChannelInfo(indexPath : IndexPath) -> ChannelProgramList? {
        return self.channelProgramList[safe : indexPath.row - 1]
    }
    
    func getChannelProgramInfo(indexPath : IndexPath) -> Program? {
        return self.channelProgramList[safe : indexPath.row - 1]?.programList[safe : indexPath.column - 1]
    }
    
    func getHoursinfo(indexPath : IndexPath) -> String {
        return self.timeIntervals[safe: indexPath.column - 1]?.toString(dateFormat: DateFormat.Time) ?? ""
    }
    
    func getTitle() -> String {
        return "VMedia"
    }
    
    func getTodaysDateString() -> String {
        let todaysString  = currentDate.getReadableDateStringFromDate(date: currentDate)
        return "Today, \(todaysString)"
    }
    
    func setChannelListData() {
        setTimeHours()
        setChannelProgramlist()
        
    }
    
    func  setChannelProgramlist() {
        for eachChannel in self.channels {
            let programList  = self.programList.filter({$0.recentAirTime?.channelID == eachChannel.id})
            let channelProgram  = ChannelProgramList(channelName: eachChannel.callSign, channelId: eachChannel.id, channelOrderNum: eachChannel.orderNum, programList: createProgramList(list: programList))
            self.channelProgramList.append(channelProgram)
        }
    }
    
    func createProgramList(list : [ChannelProgram]) -> [Program] {
        var programSortList = list.map { (program) -> Program in
            let startTimeDate  = (program.startTime ?? "").getDate() ?? Date()
            let startTimeStr  = startTimeDate.toString(dateFormat: DateFormat.Time)
            let program =  Program(name: program.name, startTime: startTimeStr, startTimeDate: startTimeDate, length: program.length, programId: program.recentAirTime?.id)
            return program
        }
        programSortList = programSortList.sorted { program1, program2 in
            return program1.startTimeDate ?? Date() < program2.startTimeDate ?? Date()
        }
        
        return programSortList
    }
    
    func setTimeHours() {
        let calendar = Calendar.current
        let startDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
        var currentDate = startDate
        while currentDate <= endDate {
            timeIntervals.append(currentDate)
            currentDate = calendar.date(byAdding: .minute, value: 30, to: currentDate)!
        }
        print(timeIntervals)
    }
    
}

extension ChannelListPresentor: ChannelListInteractorOutputProtocol {
    func didFetchChannelProgramListData(result: Result<[ChannelProgram], NetworkError>) {
        switch result {
        case .success(let data):
            self.programList  = data
            break
        case .failure(let _):
            break
        }
        self.sempaphore.signal()
    }
    
    func didFetchChannelListData(result: Result<[Channel], NetworkError>) {
        switch result {
        case .success(let data):
            self.channels  = data
            break
        case .failure(let _):
            break
        }
        self.sempaphore.signal()
    }
    
    func didFetchChannels(_ channels: [Channel]) {
        self.channels = channels
        view?.reloadData()
    }
}

