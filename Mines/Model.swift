//
//  Model.swift
//  Mines
//
//  Created by segev perets on 13/01/2024.
//

import UIKit

class Model {
    func populateView(_ view:UIView,rows:Int = 10,startingHeight:CGFloat = 250) {
        let y: CGFloat = 35
        let maxRows = Int(view.frame.height / y)
        guard rows < maxRows else {fatalError("No space for that many rows")}
        let reminder = Int(view.frame.width)%Int(y)/2
        var x: CGFloat = 0 + CGFloat(reminder)
        
        
        print(maxRows)
        for i in 0..<rows {
            let row = CGFloat(i * 35)
            while x < view.frame.width - y {
                if Bool.random(),Bool.random(),Bool.random() {
                    view.addSubview(LandView(data: .mine,
                                             origin: .init(x: x,
                                                           y: startingHeight + row)))
                    
                } else {
                    view.addSubview(LandView(origin: .init(x: x,
                                                           y: startingHeight + row)))
                }
                x += y
            }
            x = 0 + CGFloat(reminder)
        }

    }
    func revealAll(in view:UIView) {
        var i = 0
        view.subviews.forEach { aView in
            if let aView = aView as? LandView {
                guard !aView.isRevealed else {return}
                aView.reveal()
                i += 1
            }
        }
    }
    
}
