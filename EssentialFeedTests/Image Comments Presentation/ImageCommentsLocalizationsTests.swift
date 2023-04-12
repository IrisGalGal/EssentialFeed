//
//  ImageCommentsLocalizationsTests.swift
//  EssentialFeedTests
//
//  Created by Iris GalGal on 12/04/23.
//

import XCTest
import EssentialFeed

final class ImageCommentsLocalizationsTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
    
}

