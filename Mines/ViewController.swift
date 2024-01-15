//
//  ViewController.swift
//  Mines
//
//  Created by segev perets on 12/01/2024.
//

import UIKit

class ViewController: UIViewController {

    var grid: MineGrid?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(revealAll)))
        grid = MineGrid(rows: 10, columns: 10,to: view)
        grid?.addToView(view)
    }
    
    @objc private func revealAll() {
        grid?.revealAll()
    }
    
    
    
}


