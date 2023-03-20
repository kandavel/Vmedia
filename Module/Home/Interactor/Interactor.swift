//
//  Interactor.swift
//  Vmedia
//
//  Created by kandavel on 18/03/23.
//

import Foundation

protocol ChannelListInteractorProtocol: AnyObject {
    var presenter: ChannelListInteractorOutputProtocol? { get set }
    var networkManager: NetworkManagerProtocol? { get set }
    func fetchChannelListData()
    func fetchChannelProgramListData()
}

protocol ChannelListInteractorOutputProtocol: AnyObject {
    func didFetchChannelListData(completionhandler : Result<[Channel], NetworkError>)
    func didFetchChannelProgramListData(completionhandler : Result<[ChannelProgram], NetworkError>)
}
class ChannelListViewInteractor : ChannelListInteractorProtocol {
   weak var presenter: ChannelListInteractorOutputProtocol?
   weak var networkManager: NetworkManagerProtocol?
}

extension ChannelListViewInteractor  {
    func fetchChannelListData() {
        networkManager?.request(Router.channelList(page: ""), decodeToType: [Channel].self, completionHandler: { (result) in
            self.presenter?.didFetchChannelListData(completionhandler: result)
        })
    }
    
    func fetchChannelProgramListData() {
        networkManager?.request(Router.channelProgramList(page: ""), decodeToType: [ChannelProgram].self, completionHandler: { (result) in
            self.presenter?.didFetchChannelProgramListData(completionhandler: result)
        })
    }
}
