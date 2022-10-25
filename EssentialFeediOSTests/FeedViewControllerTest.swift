//
//  FeedViewControllerTest.swift
//  EssentialFeediOSTests
//
//  Created by IrisDarka on 25/10/22.
//

import XCTest
import UIKit
import EssentialFeed
final class FeedViewController: UITableViewController{
    private var loader : FeedLoader?
    convenience init(loader: FeedLoader){
        self.init()
        self.loader = loader
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        refreshControl?.beginRefreshing()
        load()
    }
    @objc private func load(){
        loader?.load{ [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}
class FeedViewControllerTest: XCTestCase {
    func test_init_doesNotLoadFeed(){
        let (_,loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    func test_viewDidLoad_loadsFeed(){
        let (sut,loader) = makeSUT()

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    func test_pullToRefresh_loadsFeed(){
        let (sut,loader) = makeSUT()
        sut.loadViewIfNeeded()
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 2)
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    func test_viewDidLoad_showsLoadingIndicator(){
        let (sut,_) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }
    func test_viewDidLoad_hidesLoadingIndicatorOnLoaderCompletion(){
        let (sut,loader) = makeSUT()
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    func test_pullToRefresh_showsLoadingIndicator(){
        let (sut,_) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }
    
    func test_pullToRefresh_hidesLoadingIndicatorOnLoaderCompletion(){
        let (sut,loader) = makeSUT()
        sut.refreshControl?.simulatePullToRefresh()
        loader.completeFeedLoading()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line:UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy){
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut,loader)
    }

    class LoaderSpy: FeedLoader{
        private var completions = [(FeedLoader.LoadFeedResult)->Void]()
        
        var loadCallCount: Int{
            return completions.count
        }
        
        func load(completion: @escaping (FeedLoader.LoadFeedResult) -> Void) {
            completions.append(completion)
        }
        func completeFeedLoading(){
            completions[0](.success([]))
        }
    }
}
private extension UIRefreshControl{
    func simulatePullToRefresh(){
        allTargets.forEach { target  in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach{
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
