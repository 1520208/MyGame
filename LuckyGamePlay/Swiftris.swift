//
//  Swiftris.swift
//  LuckyGamePlay
//
//  Created by Jacqueline on 23.05.17.
//  Copyright © 2017 Jackys Code Factory. All rights reserved.
//

//definition of total number of rows and columns, location where each piece starts and the preview piece belongs
let NumColumns = 10
let NumRows = 20
let StartingColumn = 4
let StartingRow = 0
let PreviewColumn = 12
let PreviewRow = 1

class Swiftris{
    var blockArray:Array2D<Block>
    var nextShape:Shape?
    var fallingShape:Shape?
    
    init(){
        fallingShape = nil
        nextShape = nil
        blockArray = Array2D<Block>(columns: NumColumns, rows:NumRows )
        
    }
    
    func beginGame() {
        if (nextShape == nil) {
            nextShape = Shape.random(startingColumn:PreviewColumn, startingRow: PreviewRow)
        }
    }
    
    //method which assigns the preview shape as nextShape, fallingShape is the moving Tetromino
    //method creates a new preview shape before moving fallingShape to the starting row and column
    //@return tuple of optional Shape objects
    
    func newShape() ->(fallingShape:Shape?, nextShape:Shape?){
        fallingShape = nextShape
        nextShape = Shape.random(startingColumn:PreviewColumn, startingRow:PreviewRow)
        fallingShape?.moveTo(column:StartingColumn, row:StartingRow)
        return (fallingShape, nextShape)
        
    }
}
