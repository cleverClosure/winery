//
//  PageViewController.swift
//  Winery
//
//  Created by Tim on 02.04.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit
import Cartography


class PageItemController: UIViewController {
    
    var wine: Wine? {
        didSet {
            self.cardView.wine = wine
        }
    }
    
    lazy private var cardView: CardView = {
        let cardView = CardView(frame: CGRect.zero)
        cardView.layer.cornerRadius = (self.view.frame.width * Constants.PageItem.cardViewWidthMultiplier) / 16
        return cardView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(cardView)
        constrain(cardView) { cardView in
            cardView.width == cardView.superview!.width * Constants.PageItem.cardViewWidthMultiplier
            cardView.height == cardView.width * 1.5
            cardView.center == cardView.superview!.center
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func animateCardViewAfterScroll() {
        cardView.animateAfterScroll()
    }

}
