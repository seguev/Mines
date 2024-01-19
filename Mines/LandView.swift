//
//  LandView.swift
//  Mines
//
//  Created by segev perets on 12/01/2024.
//

import UIKit


class LandView: UIView {
    weak var grid: MineGrid?
    var isRevealed: Bool = false
    var coordinates: (row:Int,column:Int)
    var data: LandViewData
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        return imageView
    }()
    
    func add() {
        if var n = fetchNumber() {
            n += 1
            data = .number(n)
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
    
    init( origin:CGPoint,size:CGSize = .init(width: 35, height: 35),mineFactor:Int = 3, grid:MineGrid, coordinates: (row:Int,column:Int)) {
        if Int.random(in: 0..<mineFactor) == 0 {
            self.data = .mine
        } else {
            self.data = .number(0)
        }
        self.grid = grid
        self.coordinates = coordinates
        
        super.init(frame: .init(origin: origin, size: size))
        self.addSubview(imageView)
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
        
        imageView.transform = .init(scaleX: 0.7, y: 0.7)
        imageView.image = .flag
        grid?.checkIfWon()
    }
    
    @objc func reveal(_ sender:UITapGestureRecognizer? = nil) {
        guard !isRevealed else {return}
        isRevealed = true
        
        if data == .mine {
            
            backgroundColor = .red
            imageView.image = .mine
            imageView.transform = .init(scaleX: 1.3, y: 1.3)
            grid?.delegate?.gameOver()
        } else {
            
            backgroundColor = .systemGray6
            imageView.image = nil
            let n = fetchNumber()
            let isEmpty = n == 0
            
            if isEmpty {
                numLabel.text = ""
                //open nearby cells
                forEachSurroundingView { centerMine, surroundingMine in
                    surroundingMine.reveal()
                }
            } else {
                imageView.image = nil
                numLabel.text = n?.description
            }
        }
    }
    
    func forEachSurroundingView(do task:(_ centerMine:LandView,_ surroundingMine:LandView)->Void) {
        guard let grid else {return}
        let n = self.coordinates.row
        let m = self.coordinates.column
        let rows = grid.grid.count
        let columns = grid.grid[0].count
        
        for i in -1...1 {
            for j in -1...1 {
                let x = n + i
                let y = m + j
                
                let isInside = x >= 0 &&
                y >= 0 &&
                x < rows &&
                y < columns
                
                guard isInside else {continue}
                
                let targetMine = grid.grid[x][y]
                task(self, targetMine)
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


