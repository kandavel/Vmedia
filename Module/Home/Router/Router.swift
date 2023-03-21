//
//  Router.swift
//  Vmedia
//
//  Created by kandavel on 18/03/23.
//

import Foundation
import UIKit

protocol ChannelListProtocol: AnyObject {
    static func createHomeModule() -> UIViewController
}

class ChannelListRouter: ChannelListProtocol {

    static func createHomeModule() -> UIViewController {
        let presenter: ChannelListPresentorProtocol & ChannelListInteractorOutputProtocol = ChannelListPresentor()
        let interactor: ChannelListInteractorProtocol = ChannelListViewInteractor()
        let wireframe: ChannelListProtocol = ChannelListRouter()
        let networkManager: NetworkManagerProtocol = NetworkManager()
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        interactor.presenter = presenter
        interactor.networkManager = networkManager
        let view = ChannelListViewController(view: presenter)
        presenter.view = view
        return view
    }

}
