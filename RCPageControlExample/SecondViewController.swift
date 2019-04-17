//
//  SecondViewController.swift
//  RCPageControlExample
//
//  Created by Looping on 2019/4/17.
//  Copyright © 2019 Looping. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    var numberOfPages = 6
    var pageViews: iCarousel?
    var pageControlRC: RCPageControl?
    var pageControlUI: UIPageControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        
        pageViews = iCarousel(frame: self.view.frame)
        pageViews!.delegate = self
        pageViews!.dataSource = self
        pageViews!.isPagingEnabled = true
        self.view.addSubview(pageViews!)
        
        pageControlRC = RCPageControl(numberOfPages: numberOfPages)
        pageControlRC!.center = CGPoint(x: self.view.center.x, y: self.view.frame.size.height - 160.0)
        pageControlRC!.currentPageChangedBlock = { (pageControl) in
            self.pageViews!.scrollToItem(at: pageControl!.currentPage, animated: true)
            }
        self.view.addSubview(pageControlRC!)
        
        pageControlUI = UIPageControl()
        pageControlUI!.numberOfPages = numberOfPages
        pageControlUI!.center = CGPoint(x: self.view.center.x, y: 160.0)
        pageControlUI!.addTarget(self, action: #selector(changePage(sender:)), for: .valueChanged)
        
        self.view.addSubview(pageControlUI!)
    }
    
    @objc func changePage(sender: AnyObject) {
        pageViews!.scrollToItem(at: pageControlUI!.currentPage, animated:true)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return numberOfPages
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var theNewView = view
        if theNewView == nil {
            theNewView = UIView(frame: self.view.frame)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            imageView.center = theNewView!.center
            imageView.image = UIImage(named: "avatar")
            imageView.layer.cornerRadius = imageView.frame.size.height / 2
            imageView.layer.masksToBounds = true
            
            theNewView!.addSubview(imageView)
        }
        
        let color = index % 3 >= 1 ? (index % 2 >= 1 ? UIColor.red.withAlphaComponent(0.5) : UIColor.green.withAlphaComponent(0.5)) : UIColor.orange.withAlphaComponent(0.5)
        theNewView!.backgroundColor = color
        
        return theNewView!
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        pageControlRC!.currentPage = carousel.currentItemIndex
        pageControlUI!.currentPage = carousel.currentItemIndex
    }
}
