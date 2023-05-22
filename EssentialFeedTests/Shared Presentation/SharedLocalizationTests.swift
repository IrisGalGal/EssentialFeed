//
//  SharedLocalizationStrings.swift
//  EssentialFeedTests
//
//  Created by Iris GalGal on 31/03/23.
//

import XCTest
import EssentialFeed

final class SharedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
    
    private class DummyView: ResourceView {
        
        typealias ResourceViewModel = String
        
        func display(_ viewModel: Any) {
            
        }
        
        func display(_ viewModel: String) {
            
        }
    }
    
    // MARK: - Helpers
    
}

