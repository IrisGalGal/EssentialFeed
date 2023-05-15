//
//  LoadMoreCellController.swift
//  EssentialFeediOS
//
//  Created by Iris GalGal on 5/15/23.
//

import UIKit
import EssentialFeed

public class LoadMoreCellController: NSObject, UITableViewDataSource{
    let cell = LoadMoreCell()
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

}

extension LoadMoreCellController: ResourceLoadingView{
    public func display(_ viewModel: EssentialFeed.ResourceLoadingViewModel) {
        cell.isLoading = viewModel.isLoading
    }
}
