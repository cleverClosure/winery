//
//  CardView.swift
//  Winery
//
//  Created by Tim on 02.04.2018.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit
import Cartography

class CardView: UIView {
    
    var wine: Wine? {
        didSet {
            self.updateData()
        }
    }
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var subTitle: String? {
        didSet {
            self.subTitleLabel.text = subTitle
        }
    }
    
    lazy private var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "UltimaAlt-Bold", size: 22)
        label.text = self.title ?? "CHARDONE"
        return label
    }()
    
    lazy private var subTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "UltimaAlt-Bold", size: 18)
        label.text = self.subTitle ?? "GOOD WINE"
        label.textColor = .lightGray
        return label
    }()
    
    private var wineView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "calcinaires")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var price: Float = 550.0 {
        didSet {
            priceLabel.text = "$\(price)"
        }
    }
    
    lazy private var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$\(price)"
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "Ultima", size: 22)
        return label
    }()
    
    private let line: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "line")
        return image
    }()
    
    lazy private var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("BUY NOW", for: UIControlState.normal)
        button.setTitleColor(tint, for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.layer.borderColor = tint.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        return button
    }()
    
    var tint: UIColor = UIColor.black
    
    let wineCenterXConstrainGroup = ConstraintGroup()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAppearance()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAppearance() {
        self.backgroundColor = .white
        self.layer.shadowRadius = 14
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 1, height: 3)
    }
    
    private func setupViews() {
        let titleStack = UIStackView()
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(subTitleLabel)
        titleStack.spacing = 10
        titleStack.axis = .vertical
        titleStack.alignment = .center
        self.addSubview(titleStack)
        self.addSubview(wineView)
        self.addSubview(priceLabel)
        self.addSubview(line)
        self.addSubview(buyButton)
        constrain(titleStack, wineView, priceLabel, line, buyButton) { titleStack, wineView, priceLabel, line, buyButton in
            titleStack.top == titleStack.superview!.topMargin + 25
            titleStack.centerX == titleStack.superview!.centerX
            wineView.width == wineView.superview!.width * 0.65
            wineView.height == wineView.width * 0.4
            wineView.bottom == wineView.superview!.centerY - 30
            priceLabel.centerY == priceLabel.superview!.centerY + 50
            priceLabel.centerX == priceLabel.superview!.centerX
            line.top == priceLabel.bottom + 20
            line.centerX == line.superview!.centerX
            buyButton.top == line.bottom + 20
            buyButton.centerX == buyButton.superview!.centerX
            buyButton.width == buyButton.superview!.width * 0.5
        }
        
        constrain(wineView, replace: wineCenterXConstrainGroup) { wineView in
            wineView.centerX == wineView.superview!.centerX
        }
    }
    
    func updateData() {
        guard let wine = wine else {
            return
        }
        self.title = wine.title
        self.subTitle = wine.subtitle
        self.price = wine.price
        self.wineView.image = UIImage(named: wine.name)
    }
    
    func animateAfterScroll() {
        constrain(wineView, replace: wineCenterXConstrainGroup) { wineView in
            wineView.centerX == wineView.superview!.centerX - 10
        }
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [unowned self] in
            constrain(self.wineView, replace: self.wineCenterXConstrainGroup) { wineView in
                wineView.centerX == wineView.superview!.centerX
            }
            self.layoutIfNeeded()
        }, completion: nil)
    }


}
