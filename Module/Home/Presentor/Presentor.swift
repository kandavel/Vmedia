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
    
}

class ChannelListPresentor: ChannelListPresentorProtocol {
    

    weak var view: HomeViewProtocol?
    weak var interactor: ChannelListInteractorProtocol?
    weak var wireframe: ChannelListProtocol?

    var channels: [Channel] = []
    var channelProgramList : [ChannelProgram] = []
    let dispatchGroup  = DispatchGroup()

    func viewDidLoad() {
        DispatchQueue.global(qos: .background).async {
            self.dispatchGroup.enter()
            self.interactor?.fetchChannelListData()
            self.dispatchGroup.enter()
            self.interactor?.fetchChannelProgramListData()
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            
        })
    }
    
    func  setChannelProgramlist() {
        
    }
    

}

extension ChannelListPresentor: ChannelListInteractorOutputProtocol {
    func didFetchChannelProgramListData(completionhandler: Result<[ChannelProgram], NetworkError>) {
        switch completionhandler {
        case .success(let data):
            self.channelProgramList  = data
            break
        case .failure(let error):
            break
        }
        self.dispatchGroup.leave()
    }
    
    func didFetchChannelListData(completionhandler: Result<[Channel], NetworkError>) {
        switch completionhandler {
        case .success(let data):
            self.channels  = data
            break
        case .failure(let error):
            break
        }
        self.dispatchGroup.leave()
    }
    
    func didFetchChannels(_ channels: [Channel]) {
        self.channels = channels
        view?.reloadData()
    }
}

