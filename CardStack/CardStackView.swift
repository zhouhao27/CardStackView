//
//  CardStackView.swift
//  CardStack
//
//  Created by Zhou Hao on 11/3/17.
//  Copyright © 2017 Zhou Hao. All rights reserved.
//

import UIKit

protocol CardStackViewDataSource: class {
    func nextCard(in: CardStackView) -> CardView
    func cardStackView(_ cardStackView: CardStackView, cardAt index: Int) -> CardView
    func numOfCardInStackView(_ cardStackView: CardStackView) -> Int
}

protocol CardStackDelegate {
    func cardStackView(_: CardStackView, didSelectCardAt: Int)
}

@IBDesignable
class CardStackView: UIView, CardViewDelegate {

    // MARK: - Properties
    weak var dataSource: CardStackViewDataSource?   // TODO: add to dataSource in Inspector
    
    // MARK: - Private properties
    private var nib : UINib?
    
    // MARK: - Inspectable properties
    @IBInspectable
    var offsetY: CGFloat = 0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var scaleFactor: Float = 0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Public methods
    func register(nib: UINib) {
        self.nib = nib
    }
    
    func dequeueCardView() -> CardView {
        if let view = nib?.instantiate(withOwner: self, options: nil).first as? CardView {
            return view
        } else {
            return CardView()
        }
    }
    
    func reloadData() {
        subviews.forEach { $0.removeFromSuperview() }
        
        if let dataSource = dataSource {
            let total = dataSource.numOfCardInStackView(self)
    
            var prevView: UIView?
            for i in 0..<total {
                let cardView = dataSource.cardStackView(self, cardAt: i)
                cardView.delegate = self
                if let prevView = prevView {
                    self.insertSubview(cardView, belowSubview: prevView)
                } else {
                    addSubview(cardView)
                }
                prevView = cardView
            }
            
            layoutIfNeeded()
        }
    }
    
    // MARK: - CardViewDelegate
    
    func shouldRemoveCardView(_ cardView: CardView) {
        if let nextCard = dataSource?.nextCard(in: self) {
            nextCard.delegate = self
            // always in last
            insertSubview(nextCard, at: 0)
        }
    }
    
    // MARK: - Override
    override func layoutSubviews() {
        
        // setup cards frame
        var index = 0
        for cardView in subviews.reversed() {
            if cardView.isKind(of: CardView.self) {
                cardView.frame = rectAt(index: index)
                index += 1
            }
        }
        
    }
    
    // MARK: - Private methods
    func setup() {
    }

    private func rectAt(index: Int) -> CGRect {
        
        if let dataSource = dataSource {
            let total = dataSource.numOfCardInStackView(self)
            
            let w = bounds.width
            let h = bounds.height - CGFloat(total - 1) * offsetY
        
            let scale = CGFloat(pow(scaleFactor, Float(index)))
            let x = ( w - w * scale ) / 2.0
            let y = CGFloat(index)*offsetY + ( h - h * scale )
            return CGRect(x: x, y: y, width: w * scale, height: h * scale)
        }
        return CGRect.zero
    }
}
