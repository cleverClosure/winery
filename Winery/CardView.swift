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
    
    var delegate: CardViewDelegate?
    
    var wine: Wine? {
        didSet {
            self.updateData()
        }
    }
    
    lazy private var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "UltimaAlt-Bold", size: 22)
        label.text = wine?.title ?? "CHARDONE"
        return label
    }()
    
    lazy private var subTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "UltimaAlt-Bold", size: 18)
        label.text = wine?.subtitle ?? "GOOD WINE"
        label.textColor = .lightGray
        return label
    }()
    
    let titleStack = UIStackView()
    
    private var wineView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "calcinaires")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var price: Float = 550.0 {
        didSet {
            priceLabel.text = "$\(price)"
        }
    }
    
    lazy private var priceLabel: UILabel = {
        let label = UILabel()
        let price = wine?.price ?? 0
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
    
    lazy private var descriptionView: UILabel = {
        let textView = UILabel()
        textView.text = wine?.description ?? ""
        textView.isHidden = true
        textView.textColor = .gray
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textAlignment = .center
        textView.alpha = 0
        textView.numberOfLines = 8
        return textView
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
    
    let wineCenterXConstraintGroup = ConstraintGroup()
    let generalConstraintGroup = ConstraintGroup()
    
    let productWidth = UIScreen.main.bounds.width * 0.55
    
    var isInDetailMode = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAppearance()
        setupViews()
        setupTouchEvents()
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
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(subTitleLabel)
        titleStack.spacing = 10
        titleStack.axis = .vertical
        titleStack.alignment = .center
        self.addSubview(titleStack)
        self.addSubview(wineView)
        self.addSubview(priceLabel)
        self.addSubview(descriptionView)
        self.addSubview(line)
        self.addSubview(buyButton)
        setGeneralConstraints()
        setInitialAnimationConstraints()
        setFinalProductXPosition()
    }
    
    func updateData() {
        guard let wine = wine else {
            return
        }
        self.titleLabel.text = wine.title
        self.subTitleLabel.text = wine.subtitle
        self.priceLabel.text = "$\(wine.price)"
        self.descriptionView.text = wine.description
        self.wineView.image = UIImage(named: wine.name)
    }
    
    fileprivate func setGeneralConstraints() {
        constrain(wineView, titleStack, priceLabel, line, buyButton, descriptionView) { wineView, titleStack, priceLabel, line, buyButton, descriptionView in
            wineView.width == productWidth
            wineView.height == wineView.width * 0.4
            titleStack.centerX == titleStack.superview!.centerX
            priceLabel.centerX == priceLabel.superview!.centerX
            line.top == priceLabel.bottom + 20
            line.centerX == line.superview!.centerX
            buyButton.bottom == buyButton.superview!.bottom - 30
            buyButton.centerX == buyButton.superview!.centerX
            buyButton.width == 150
            descriptionView.centerX == descriptionView.superview!.centerX
            descriptionView.width == descriptionView.superview!.width * 0.8
        }
    }
    
    fileprivate func setInitialAnimationConstraints() {
        constrain(wineView, titleStack, priceLabel, descriptionView, replace: generalConstraintGroup) { wineView, titleStack, priceLabel, descriptionView in
            wineView.centerY == wineView.superview!.centerY - 30
            titleStack.top == titleStack.superview!.topMargin + 30
            priceLabel.centerY == priceLabel.superview!.centerY + 50
            descriptionView.top == descriptionView.superview!.bottom
        }
    }
    
    fileprivate func setFinalAnimationConstraints() {
        constrain(wineView, titleStack, priceLabel, descriptionView, replace: generalConstraintGroup) { wineView, titleStack, priceLabel, descriptionView in
            wineView.centerY == wineView.superview!.top
            titleStack.top == titleStack.superview!.topMargin + 60
            priceLabel.top == titleStack.bottom + 10
            descriptionView.top == priceLabel.bottom + 10
        }
    }
    
    
    func animateAfterScroll() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { [unowned self] in
            self.setFinalProductXPosition()
        }, completion: nil)
        self.layoutIfNeeded()
    }
    
    func setInitialProductXPosition() {
        constrain(wineView, replace: wineCenterXConstraintGroup) { wineView in
            wineView.centerX == wineView.superview!.centerX - 20
        }
        self.layoutIfNeeded()
    }
    
    func setFinalProductXPosition() {
        constrain(wineView, replace: wineCenterXConstraintGroup) { wineView in
            wineView.centerX == wineView.superview!.centerX
        }
        self.layoutIfNeeded()
    }
    
    func setupTouchEvents() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProduct))
        wineView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapProduct() {
        delegate?.didTapProduct()
        isInDetailMode = !isInDetailMode
    }
    
    func animateDetailMode() {
        self.descriptionView.isHidden = false
        UIView.animate(withDuration: Constants.animationSpeed, delay: 0, options: [.curveEaseOut], animations: { [unowned self] in
            self.setFinalAnimationConstraints()
            self.layoutIfNeeded()
            self.line.isHidden = true
            self.descriptionView.alpha = 1
        }, completion: nil)
    }
    
    func animateShortMode() {
        UIView.animate(withDuration: Constants.animationSpeed / 2, delay: 0, options: [.curveEaseOut], animations: { [unowned self] in
            self.descriptionView.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: Constants.animationSpeed, delay: 0, options: [.curveEaseOut], animations: { [unowned self] in
            self.setInitialAnimationConstraints()
            self.layoutIfNeeded()
            self.line.isHidden = false
            }, completion: { isComplete in
                if isComplete {
                    self.descriptionView.isHidden = true
                }
        })
    }
}

extension CardView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.bounds.contains(point) || wineView.frame.contains(point) {
            return true
        }
        return false
    }
}

protocol CardViewDelegate {
    func didTapProduct()
}
