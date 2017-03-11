//
//  ViewController.swift
//  CardStack
//
//  Created by Zhou Hao on 11/3/17.
//  Copyright © 2017 Zhou Hao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CardStackViewDataSource {

    @IBOutlet weak var cardStackView: CardStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardStackView.register(nib: UINib(nibName: "MyCard", bundle: nil))
        cardStackView.dataSource = self
        cardStackView.reloadData()
    }

    override func viewDidLayoutSubviews() {
//        print(cardStackView.frame)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func nextCard(in: CardStackView) -> CardView {
        let card = cardStackView.dequeueCardView()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label.text = "new"
        card.addSubview(label)
        return card
    }
    
    func cardStackView(_ cardStackView: CardStackView, cardAt index: Int) -> CardView {
        let card = cardStackView.dequeueCardView() as! MyCard
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
//        label.text = "\(index)"
//        card.addSubview(label)
            
        card.numberLabel.text = "\(index)"
        return card
    }
    
    func numOfCardInStackView(_ cardStackView: CardStackView) -> Int {
        return 3
    }

}

