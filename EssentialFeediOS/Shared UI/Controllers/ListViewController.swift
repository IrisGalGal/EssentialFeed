//
//  ListViewController.swift
//  EssentialFeediOS
//
//  Created by IrisGal on 25/10/22.
//

import UIKit
import EssentialFeed

 public final class ListViewController: UITableViewController, UITableViewDataSourcePrefetching, ResourceLoadingView, ResourceErrorView{
    @IBOutlet private(set) public var errorView: ErrorView?
     
    private var loadingControllers = [IndexPath: CellController]()
     
    private var tableModel = [CellController]() {
        didSet { tableView.reloadData() }
    }
    
    public var onRefresh: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    public func display(_ cellControllers: [CellController]){
        loadingControllers = [:]
        tableModel = cellControllers
    }
    @IBAction private func refresh(){
        onRefresh?()
    }
    
     public func display(_ viewModel: ResourceLoadingViewModel) {
        if viewModel.isLoading{
            refreshControl?.beginRefreshing()
        }else{
            refreshControl?.endRefreshing()
        }
    }
     public func display(_ viewModel: ResourceErrorViewModel) {
        if let message = viewModel.message {
            errorView?.show(message: message)
         } else {
            errorView?.hideMessage()
         }
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.sizeTableHeaderToFit()
    }
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = cellController(forRowAt: indexPath).dataSource
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = removeLoadingController(forRowAt: indexPath)?.delegate
        dl?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
     
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = cellController(forRowAt: indexPath).delegate
        dl?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = cellController(forRowAt: indexPath).datasourcePrefetching
            dsp?.tableView(tableView, prefetchRowsAt: [indexPath])
        }
    }
    private func cellController(forRowAt indexPath: IndexPath) -> CellController{
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = removeLoadingController(forRowAt: indexPath)?.datasourcePrefetching
            dsp?.tableView(tableView, prefetchRowsAt: [indexPath])
        }
    }

    private func removeLoadingController(forRowAt indexPath: IndexPath) -> CellController? {
        let controller = loadingControllers[indexPath]
        loadingControllers[indexPath] = nil
        return controller
    }
}
