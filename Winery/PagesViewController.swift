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
    
    var pages: [PageItemController] = {
        let colors = [UIColor(hex: 0xffbe76), UIColor(hex: 0xbadc58), UIColor(hex: 0xe17055)]
        var pages = [PageItemController]()
        for color in colors {
            let page = PageItemController()
            page.view.backgroundColor = color
            pages.append(page)
        }
        return pages
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
    

}

extension PagesViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return pages.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        
        return pages[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

extension PagesViewController: PageboyViewControllerDelegate {
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        print("st ", pageboyViewController.currentIndex, self.lastPageIndex)
        var newIndex = index
        switch direction {
        case PageboyViewController.NavigationDirection.forward:
            newIndex = min(index + 1, pages.count - 1)
        case PageboyViewController.NavigationDirection.forward:
            newIndex = max(index - 1, 0)
        default:
            break
        }
        
        pages[index].prepareCardForAnimation()
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        guard let currentIndex = pageboyViewController.currentIndex, currentIndex != self.lastPageIndex else {
            return
        }
        if let page = pageboyViewController.currentViewController as? PageItemController {
            page.animateCardViewAfterScroll()
        }
        lastPageIndex = currentIndex
    }
}

