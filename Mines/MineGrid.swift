//
//  MineGrid.swift
//  Mines
//
//  Created by segev perets on 13/01/2024.
//

import UIKit

class MineGrid {
    var grid: [[LandView]] = []
    private let width: CGFloat = 35
    
    private func createGrid(rows:Int,columns:Int,_ gridOrigin:CGPoint) {
        for i in 0..<rows {
            var row = [LandView]()
            for j in 0..<columns {
                let point: CGPoint = .init(x: CGFloat(i) * width + gridOrigin.x,
                                           y: CGFloat(j) * width + gridOrigin.y)
                row.append(LandView(origin: point,grid: self))
            }
            grid.append(row)
        }
    }
    
    private func fetchOrigin(inRelationFor view:UIView,rows:Int,columns:Int) -> CGPoint {
        let marginX = view.frame.width.remainder(dividingBy: width) / 2
        let totalGridWidth = width * CGFloat(columns)
        let marginLeft = marginX + (view.frame.width - totalGridWidth) / 2.0
        
        let safeAreaInsets = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets
        let (top,bottom) = (safeAreaInsets?.top ?? .zero, safeAreaInsets?.bottom ?? .zero)
        let cleanHeight = view.frame.height - top 
        
        let marginTop = (cleanHeight - totalGridWidth) / 2
        
        return .init(x: Int(marginLeft), y: Int(marginTop))
    }
    
    func addToView(_ view:UIView) {
        grid.forEach{$0.forEach{
            view.addSubview($0)
        }}
        
    }
    
    func revealAll() {
        var i = 0
        grid.forEach{$0.forEach { mine in
            guard !mine.isRevealed else {return}
            mine.reveal()
            i += 1
        }}
    }
    
//    func populateGrid() {
//
//        for (n, row) in grid.enumerated() {
//            let rows = grid.count
//            for (m, mine) in row.enumerated() {
//                let columns = row.count
//                
//                let hasLeft = m > 0
//                let hasRight = m < columns - 1
//                let hasUp = n > 0
//                let hasDown = n < rows - 1
//                let upwardsRight = hasRight && hasUp
//                let upwardsLeft = hasLeft && hasUp
//                let downwardRight = hasDown && hasRight
//                let downwardLeft = hasDown && hasLeft
//                
//                if hasLeft { //left
//                    if grid[n][m-1].data == .mine {
//                        mine.add()
//                    }
//                }
//                if hasRight { //right
//                    if grid[n][m+1].data == .mine {
//                        mine.add()
//                    }
//                }
//                if hasUp { //up
//                    if grid[n-1][m].data == .mine {
//                        mine.add()
//                    }
//                }
//                if hasDown { //down
//                    if grid[n+1][m].data == .mine {
//                        mine.add()
//                    }
//                }
//                if upwardsRight {
//                    if grid[n-1][m+1].data == .mine {
//                        mine.add()
//                    }
//                }
//                if upwardsLeft {
//                    if grid[n-1][m-1].data == .mine {
//                        mine.add()
//                    }
//                }
//                if downwardRight {
//                    if grid[n+1][m+1].data == .mine {
//                        mine.add()
//                    }
//                }
//                if downwardLeft {
//                    if grid[n+1][m-1].data == .mine {
//                        mine.add()
//                    }
//                }
//            }
//        }
//    }
    
    func forAllOfTheGrid(do mineHundler:(_ surroundingView:LandView,_ currentCell:LandView)->Void) {
        let rows = grid.count
        let columns = grid.first?.count ?? 0

        for n in 0..<rows {
            for m in 0..<columns {
                let currentCell = grid[n][m]

                for i in -1...1 {
                    for j in -1...1 {
                        let x = m + i
                        let y = n + j

                        if x >= 0 && x < columns && y >= 0 && y < rows {
                            if grid[y][x].data == .mine {
                               let surroundingView = grid[y][x]

                                mineHundler(surroundingView, currentCell)
                            }
                        }
                    }
                }
            }
        }
    }
    
    ;#warning("Continue from here")
    //TODO: this should take indecies and only look for serrounding views, not all of the grid
    func forEachSurroundingView(of:LandView,do mineHundler:(_ surroundingView:LandView,_ currentCell:LandView)->Void) {
        let rows = grid.count
        let columns = grid.first?.count ?? 0

        for n in 0..<rows {
            for m in 0..<columns {
                let currentCell = grid[n][m]

                for i in -1...1 {
                    for j in -1...1 {
                        let x = m + i
                        let y = n + j

                        if x >= 0 && x < columns && y >= 0 && y < rows {
                            if grid[y][x].data == .mine {
                               let surroundingView = grid[y][x]
                                let currentView = currentCell
                                mineHundler(surroundingView, currentCell)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func populateGrid() {
        forAllOfTheGrid { surroundingView, currentCell in
            if surroundingView.data == .mine {
                currentCell.add()
            }
        }
    }
    
    
    
//    func populateGrid() {
//        let rows = grid.count
//        let columns = grid.first?.count ?? 0
//
//        for n in 0..<rows {
//            for m in 0..<columns {
//                let currentCell = grid[n][m]
//
//                for i in -1...1 {
//                    for j in -1...1 {
//                        let x = m + i
//                        let y = n + j
//
//                        if x >= 0 && x < columns && y >= 0 && y < rows {
//                            if grid[y][x].data == .mine {
//                                currentCell.add()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    

    
    init(rows:Int,columns:Int,to view:UIView) {
        let origin = fetchOrigin(inRelationFor: view,rows: rows,columns: columns)
        createGrid(rows: rows, columns: columns,origin)
        populateGrid()
    }
    
}
