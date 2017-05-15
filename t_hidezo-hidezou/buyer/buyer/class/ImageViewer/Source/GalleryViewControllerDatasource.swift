//
//  GaleryViewControllerDatasource.swift
//  ImageViewer
//
//  Created by Kristian Angyal on 01/03/2016.
//  Copyright © 2016 MailOnline. All rights reserved.
//

import UIKit

final class GalleryViewControllerDatasource: NSObject, UIPageViewControllerDataSource {
    
	let imageControllerFactory: ImageViewControllerFactory
	let imageCount: Int
	let galleryPagingMode: GalleryPagingMode
    
    init(imageControllerFactory: ImageViewControllerFactory, imageCount: Int, galleryPagingMode: GalleryPagingMode) {
        
        self.imageControllerFactory = imageControllerFactory
        self.imageCount = imageCount
        self.galleryPagingMode =  (imageCount > 1) ? galleryPagingMode : GalleryPagingMode.Standard
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        guard let currentController = viewController as? ImageViewController else { return nil }
        let previousIndex = (currentController.index == 0) ? imageCount - 1 : currentController.index - 1
        
        switch galleryPagingMode {
            
        case .Standard:
            return (currentController.index > 0) ? imageControllerFactory.createImageViewController(imageIndex: previousIndex) : nil
            
        case .Carousel:
            return imageControllerFactory.createImageViewController(imageIndex: previousIndex)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        guard let currentController = viewController as? ImageViewController  else { return nil }
        let nextIndex = (currentController.index == imageCount - 1) ? 0 : currentController.index + 1
        
        switch galleryPagingMode {
            
        case .Standard:
            return (currentController.index < imageCount - 1) ? imageControllerFactory.createImageViewController(imageIndex: nextIndex) : nil
            
        case .Carousel:
            return imageControllerFactory.createImageViewController(imageIndex: nextIndex)
        }
    }
	
}
