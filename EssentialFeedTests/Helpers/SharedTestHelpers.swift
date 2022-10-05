//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by IrisGal on 05/10/22.
//

import Foundation
import EssentialFeed

func anyNSError() -> NSError{
   return NSError(domain: "any error", code: 0)
}
func anyURL() -> URL{
   return URL(string: "http://any-url.com")!
}
