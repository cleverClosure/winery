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
        
        return cardView
    }()
    
    var delegate: PageDelegate?
    
    var cardConstrainGroup = ConstraintGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.delegate = self
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(cardView)
        setCardConstraintsToInitialMode()
    }
    
    func setCardConstraintsToInitialMode() {
        constrain(cardView, replace: cardConstrainGroup) { cardView in
            cardView.width == cardView.superview!.width * Constants.cardViewWidthMultiplier
            cardView.height == cardView.width * 1.5
            cardView.center == cardView.superview!.center
        }
        cardView.layer.cornerRadius = (self.view.frame.width * Constants.cardViewWidthMultiplier) / 16
        view.layoutIfNeeded()
    }
    
    func setCardConstraintsToDetailMode() {
        constrain(cardView, replace: cardConstrainGroup) { cardView in
            cardView.width == cardView.superview!.width
            cardView.height == cardView.superview!.height * 0.9
            cardView.bottom == cardView.superview!.bottom
            cardView.centerX == cardView.superview!.centerX
        }
        cardView.layer.cornerRadius = 0
        view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func animateCardViewAfterScroll() {
        cardView.animateAfterScroll()
    }
    
    func prepareCardForAnimation() {
        cardView.setInitialProductXPosition()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func animateCardToDetailMode() {
        UIView.animate(withDuration: Constants.animationSpeed, delay: 0, options: [.curveEaseOut], animations: { [unowned self] in
            self.setCardConstraintsToDetailMode()
        }, completion: nil)
        cardView.animateDetailMode()
    }
    
    func animateCardToShortMode() {
        UIView.animate(withDuration: Constants.animationSpeed, delay: 0, options: [.curveEaseOut], animations: { [unowned self] in
            self.setCardConstraintsToInitialMode()
        }, completion: nil)
        cardView.animateShortMode()
    }

}

extension PageItemController: CardViewDelegate {
    func didTapProduct() {
        if !cardView.isInDetailMode {
            animateCardToDetailMode()
        } else {
            animateCardToShortMode()
        }
        delegate?.didEnterDetailMode(val: cardView.isInDetailMode)
    }
}

protocol PageDelegate {
    func didEnterDetailMode(val: Bool)
}
