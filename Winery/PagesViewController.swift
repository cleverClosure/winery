//
//  ViewController.swift
//  Winery
//
//  Created by Tim on 02.04.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit
import Pageboy

class PagesViewController: PageboyViewController {
    
    var colors: [UIColor] = {
        return [UIColor(hex: 0xffbe76), UIColor(hex: 0xbadc58), UIColor(hex: 0xe17055)]
    }()
    
    var wines = [Wine]() {
        didSet {
            self.reloadPages()
        }
    }
    
    var lastPageIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        let wineFetcher = WineFetcher()
        wineFetcher.fetch {[unowned self] (wines) in
            self.wines = wines
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPageAt(index: Int) -> PageItemController {
        let pageItemVC = PageItemController()
        pageItemVC.view.backgroundColor = self.colors[index]
        pageItemVC.wine = wines[index]
        return pageItemVC
    }

}

extension PagesViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return wines.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        
        return getPageAt(index: index)
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

extension PagesViewController: PageboyViewControllerDelegate {
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        guard let currentIndex = pageboyViewController.currentIndex, currentIndex != self.lastPageIndex else {
            return
        }
        print(lastPageIndex, currentIndex)
        if let page = pageboyViewController.currentViewController as? PageItemController {
            page.animateCardViewAfterScroll()
        }
        lastPageIndex = currentIndex
    }
}

