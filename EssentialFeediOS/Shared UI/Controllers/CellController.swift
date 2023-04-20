//
//  CellController.swift
//  EssentialFeediOS
//
//  Created by Iris GalGal on 19/04/23.
//

import UIKit

public struct CellController {
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    let datasourcePrefetching: UITableViewDataSourcePrefetching?
    
    public init(_ dataSource: UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching){
        self.dataSource = dataSource
        self.delegate = dataSource
        self.datasourcePrefetching = dataSource
    }
    public init(_ dataSource: UITableViewDataSource){
        self.dataSource = dataSource
        self.delegate = nil
        self.datasourcePrefetching = nil
    }

}
