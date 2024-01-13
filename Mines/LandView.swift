//
//  LandView.swift
//  Mines
//
//  Created by segev perets on 12/01/2024.
//

import UIKit

protocol LandViewDelegate {
    func loseGame()
}

class LandView: UIView {
    var up: LandView?
    var down: LandView?
    var left: LandView?
    var right: LandView?
    var deleagte: LandViewDelegate?
    var isRevealed: Bool = false
    
    var data: LandViewData {
        didSet {
            let n = fetchNumber()
            numLabel.text = n?.description
        }
    }
    
    private lazy var numLabel: UILabel = {
        let label = UILabel(frame: .init(origin: .zero, size: frame.size))
        label.text = ""
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    init(up: LandView? = nil, down: LandView? = nil, left: LandView? = nil, right: LandView? = nil, data: LandViewData = .number(0), origin:CGPoint,size:CGSize = .init(width: 35, height: 35)) {
        self.up = up
        self.down = down
        self.left = left
        self.right = right
        self.data = data
        super.init(frame: .init(origin: origin, size: size))
        self.addTapGesture()
        self.addSubview(numLabel)
        self.setInitialAppearance()
    }
    
    private func addTapGesture() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reveal(_:))))
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(flag(_:))))
    }
    
    @objc private func flag(_ sender:UILongPressGestureRecognizer) {
        
        guard !isRevealed else {return}
        numLabel.text = "🚩"
    }
    
    @objc func reveal(_ sender:UITapGestureRecognizer? = nil) {
        
        //first tap
        if !isRevealed {
            isRevealed = true
            //mine?
            if data == .mine {
                deleagte?.loseGame()
                backgroundColor = .red
                numLabel.text = "💣"
                
            } else {
                backgroundColor = .systemGray6
                data = .number(0)
            }
        } 
    }
    
    private func setInitialAppearance() {
        self.layer.cornerRadius = 5
        self.backgroundColor = .systemGray3
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.layer.borderWidth = 1
    }
    

    
    func fetchNumber() -> Int? {
        switch self.data {
        case .number(let int):
            return int
        case .mine:
            return nil
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum LandViewData: Equatable {
    case number(Int),mine
}
