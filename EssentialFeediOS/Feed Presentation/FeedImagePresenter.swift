//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by IrisDarka on 03/11/22.
//

import Foundation
import EssentialFeed

protocol FeedImageView{
    associatedtype Image
    func display(_ model: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image{
    private let view: View
    private let imageTransformer: (Data) -> Image?
    internal init (view: View, imageTransformer: @escaping (Data) -> Image?){
        self.view = view
        self.imageTransformer = imageTransformer
    }
    func didStartLoadingImageData(for model: FeedImage){
    
    }
    private struct InvalidImageDataError: Error{}
    func didFinishLoadingImageData(with data: Data, for model: FeedImage){
        
    }
    func didFinishLoadingImageData(with error: Error, for model: FeedImage){
        
    }
}
