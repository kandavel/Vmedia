//
//  ChannelListViewController.swift
//  Vmedia
//
//  Created by kandavel on 18/03/23.
//

import Foundation
import UIKit
import SpreadsheetView


protocol HomeViewProtocol: AnyObject {
    var presenter: ChannelListPresentorProtocol? { get set }
    func reloadData()
    func registerCollectionView()
    func showLoadingView()
    func hideLoadingView()
}

class  ChannelListViewController: BaseViewController {
    
    weak var presenter: ChannelListPresentorProtocol?
    @IBOutlet weak var channelListCollectionView: UICollectionView!
    
    init() {
        super.init(nibName: String(describing: ChannelListViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    deinit {
        
    }
    
}

extension ChannelListViewController : HomeViewProtocol  {
    func showLoadingView() {
        self.showLoading()
    }
    
    func hideLoadingView() {
        self.hideLoading()
    }
    
    func registerCollectionView() {
        
    }
    
    func reloadData() {
        
    }
}
