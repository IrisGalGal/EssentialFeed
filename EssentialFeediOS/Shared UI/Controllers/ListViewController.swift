//
//  ListViewController.swift
//  EssentialFeediOS
//
//  Created by IrisGal on 25/10/22.
//

import UIKit
import EssentialFeed

 public final class ListViewController: UITableViewController, UITableViewDataSourcePrefetching, ResourceLoadingView, ResourceErrorView{
    private(set) public var errorView = ErrorView()
     
    private var loadingControllers = [IndexPath: CellController]()
     
     private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = {
         .init(tableView: tableView) { (tableView, index, controller) -> UITableViewCell? in
             controller.dataSource.tableView(tableView, cellForRowAt: index)
     }
    }()
    private var tableModel = [CellController]() {
        didSet { tableView.reloadData() }
    }
    
    public var onRefresh: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureErrorView()
        refresh()
        tableView.dataSource = dataSource
    }
    private func configureErrorView(){
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(errorView)
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: errorView.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: container.topAnchor),
            container.bottomAnchor.constraint(equalTo: errorView.bottomAnchor),
        ])
        tableView.tableHeaderView = container
        
        errorView.onHide = { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.sizeTableHeaderToFit()
            self?.tableView.endUpdates()
        }
    }
     public func display(_ sections: [CellController]...){
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
         sections.enumerated().forEach{ section, cellControllers in
             snapshot.appendSections([section])
             snapshot.appendItems(cellControllers, toSection: section)
         }
        dataSource.apply(snapshot)
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
         errorView.message = viewModel.message

    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.sizeTableHeaderToFit()
    }
     public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
         if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory{
             tableView.reloadData()
         }
     }
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
     public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let dl = cellController(at: indexPath)?.delegate
         dl?.tableView?(tableView, didSelectRowAt: indexPath)
     }
     
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = cellController(at: indexPath)?.datasourcePrefetching
            dsp?.tableView(tableView, prefetchRowsAt: [indexPath])
        }
    }
    private func cellController(at indexPath: IndexPath) -> CellController?{
        dataSource.itemIdentifier(for: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = cellController(at: indexPath)?.datasourcePrefetching
            dsp?.tableView(tableView, prefetchRowsAt: [indexPath])
        }
    }

}
