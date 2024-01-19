//
//  ViewController.swift
//  Mines
//
//  Created by segev perets on 12/01/2024.
//

import UIKit

class ViewController: UIViewController, GridDelegate {

    var grid: MineGrid?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(revealAll)))
        grid = MineGrid(rows: 10, columns: 10,to: view)
        grid?.delegate = self
        grid?.addToView(view)
    }
    
    @objc private func revealAll() {
        grid?.revealAll()
    }
    
    #warning("Views are not being removed from superView for some reason!")
    func gameOver() {
        print(#function)
        UIView.animate(withDuration: 1) {
            self.view.backgroundColor = .red.withAlphaComponent(0.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.revealAll()
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newGame)))
    }
    
    func gameWon() {
        UIView.animate(withDuration: 1) {
            self.view.backgroundColor = .green.withAlphaComponent(0.5)
        }
    }
    
    @objc func newGame() {
        print(#function)
        self.view.backgroundColor = .white
        grid = nil
        grid = MineGrid(rows: 10, columns: 10,to: view)
        grid?.delegate = self
        grid?.addToView(view)
    }
    
    
    
}


