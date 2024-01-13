//
//  ViewController.swift
//  Mines
//
//  Created by segev perets on 12/01/2024.
//

import UIKit

class ViewController: UIViewController {

    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.populateView(view)
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(revealAll)))
    }
    
    @objc private func revealAll() {
        model.revealAll(in: view)
    }
    
    
    
}

