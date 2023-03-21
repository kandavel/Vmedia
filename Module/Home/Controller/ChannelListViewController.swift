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
    func hideView()
}

class  ChannelListViewController: BaseViewController {
    
    var presenter: ChannelListPresentorProtocol?
    @IBOutlet weak var channelListCollectionView: SpreadsheetView!
    
    init(view : ChannelListPresentorProtocol?) {
        self.presenter  = view
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
        print("ViewController :: \(String(describing: ChannelListViewController.self)) is deallocated")
    }
    
}

// MARK: -ViewUpdateMethods
extension ChannelListViewController : HomeViewProtocol  {
    func hideView() {
        self.channelListCollectionView.isHidden  = !(self.channelListCollectionView.isHidden)
    }
    
    func showLoadingView() {
        self.showLoading()
    }
    
    func hideLoadingView() {
        self.hideLoading()
    }
    
    func registerCollectionView() {
        channelListCollectionView.backgroundColor = .black
        let hairline = 1 / UIScreen.main.scale
        channelListCollectionView.intercellSpacing = CGSize(width: hairline, height: hairline)
        channelListCollectionView.gridStyle = .solid(width: hairline, color: .lightGray)
        self.channelListCollectionView.dataSource = self
        self.channelListCollectionView.delegate  = self
    }
    
    func reloadData() {
        channelListCollectionView.reloadData()
    }
}
// MARK: -SpreadSheetViewMethods
extension ChannelListViewController : SpreadsheetViewDataSource,SpreadsheetViewDelegate {
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return self.presenter?.numberOfColumnCount() ?? 0
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return self.presenter?.numberOfRowsCount() ?? 0
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 80
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 40
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
}
