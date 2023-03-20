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
        let view = ChannelListViewController()
        let presenter: ChannelListPresentorProtocol & ChannelListInteractorOutputProtocol = ChannelListPresentor()
        let interactor: ChannelListInteractorProtocol = ChannelListViewInteractor()
        let wireframe: ChannelListProtocol = ChannelListRouter()
        let networkManager: NetworkManagerProtocol = NetworkManager()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        interactor.presenter = presenter
        interactor.networkManager = networkManager
        return view
    }

}
