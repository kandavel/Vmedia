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
    func registerNib()
    func showTitle()
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
    func showTitle() {
        self.title  = self.presenter?.getTitle()
    }
    
    func registerNib() {
        self.channelListCollectionView.register(HourCell.self, forCellWithReuseIdentifier: String(describing: HourCell.self))
        self.channelListCollectionView.register(ChannelCell.self, forCellWithReuseIdentifier: String(describing: ChannelCell.self))
        self.channelListCollectionView.register(BlankCell.self, forCellWithReuseIdentifier: String(describing: BlankCell.self))
        self.channelListCollectionView.register(ProgramCell.self, forCellWithReuseIdentifier: String(describing: ProgramCell.self))
    }
    
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
        return self.presenter?.numberOfRowsCount() ?? 0
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return self.presenter?.numberOfColumnCount() ?? 0
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if column >= 1 {
            return  140
        }
        return 80
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if row >= 1 {
            return  140
        }
        return 40
    }
    
    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        var mergedCells : [CellRange] = []
        return mergedCells
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if indexPath.column == 0 && indexPath.row == 0 {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HourCell.self), for: indexPath) as! HourCell
            cell.label.text  =  self.presenter?.getTodaysDateString()
            return cell
        }
        if indexPath.column == 0 && indexPath.row > 0 {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ChannelCell.self), for: indexPath) as! ChannelCell
            let channelInfo  = self.presenter?.getChannelInfo(indexPath: indexPath)
            cell.label.text = channelInfo?.channelName
            cell.gridlines.top = .solid(width: 1, color: .white)
            cell.gridlines.bottom = .solid(width: 1, color: .white)
            cell.gridlines.left = .solid(width: 1 / UIScreen.main.scale, color: UIColor(white: 0.3, alpha: 1))
            cell.gridlines.right = cell.gridlines.left
            return cell
        }
        if indexPath.column > 0 && indexPath.row == 0 {
         let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HourCell.self), for: indexPath) as! HourCell
            cell.label.text = self.presenter?.getHoursinfo(indexPath: indexPath)
            cell.gridlines.top = .solid(width: 1, color: .white)
            cell.gridlines.bottom = .solid(width: 1, color: .white)
            return cell
        }
        if indexPath.column >= 1 && indexPath.row >= 1 {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgramCell.self), for: indexPath) as! ProgramCell
            //cell.backgroundColor = .white
            cell.label.text = self.presenter?.getChannelProgramInfo(indexPath: indexPath)?.name
            cell.label.textColor = .red
            cell.gridlines.top = .solid(width: 1, color: .green)
            cell.gridlines.bottom = .solid(width: 1, color: .green)
            return cell
        }
        return spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: BlankCell.self), for: indexPath)
    }
    
    /// Delegate
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return  (self.presenter?.numberOfColumnCount() ?? 0) > 0 ? 1 : 0
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return (self.presenter?.numberOfRowsCount() ?? 0) > 0 ? 1 : 0
    }
    
}
