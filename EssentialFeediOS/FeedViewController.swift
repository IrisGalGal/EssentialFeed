//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by IrisDarka on 25/10/22.
//

import UIKit
import EssentialFeed

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL)
    func cancelImageData(from url: URL)
}

final public class FeedViewController: UITableViewController{
    private var feedloader : FeedLoader?
    private var tableModel = [FeedImage]()
    private var imageLoader: FeedImageDataLoader?
    
    public convenience init(loader: FeedLoader, imageLoader: FeedImageDataLoader){
        self.init()
        self.feedloader = loader
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load(){
        refreshControl?.beginRefreshing()
        feedloader?.load{ [weak self] result in
            if let feed = try? result.get(){
                self?.tableModel = feed
                self?.tableView.reloadData()
            }
            self?.refreshControl?.endRefreshing()

        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = (cellModel.location == nil)
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        imageLoader?.loadImageData(from: cellModel.url)
        return cell
    }
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellModel = tableModel[indexPath.row]
        imageLoader?.cancelImageData(from: cellModel.url)
    }
}
