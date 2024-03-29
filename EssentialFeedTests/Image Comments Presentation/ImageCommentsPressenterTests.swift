//
//  ImageCommentsPressenterTests.swift
//  EssentialFeedTests
//
//  Created by Iris GalGal on 12/04/23.
//

import XCTest
import EssentialFeed

final class ImageCommentsPressenterTests: XCTestCase {
    
    func test_title_isLocalized(){
        XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
    }
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
