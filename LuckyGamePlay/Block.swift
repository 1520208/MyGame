//
//  Block.swift
//  LuckyGamePlay
//
//  Created by Jacqueline on 23.05.17.
//  Copyright © 2017 Jackys Code Factory. All rights reserved.
//

import SpriteKit

//#1 definition of colors available in the game

let NumberOfColors: UInt32 = 6

//#2 declaration of enumeration, implements the customstringconvertible protocol

enum BlockColor: Int, CustomStringConvertible{
    
    //#3
    case Blue = 0, Orange, Purple, Red, Teal, Yellow
    
    //#4 computed property (behaves like a typical variable, but when accessing it a code block generates its value each time)
    
    var spriteName: String{
        switch self{
        case .Blue:
            return "blue"
            
        case .Orange:
            return "orange"
        
        case .Purple:
            return "purple"
        
        case .Red:
            return "red"
        
        case .Teal:
            return "teal"
            
        case .Yellow:
            return "yellow"
        }
    }
    
    //#5 computed property: description, returns the spriteName of the color to describe the object
    
    var description: String{
        return self.spriteName
    }
    
    //#6 static function, returns a random choice among the colors found in BlockColor, creates a block color using the rawValue:Int initializer to setup an enumeration which assigned to the numerical value passed into it (here: from 0 to 5)
    
    static func random() -> BlockColor{
        return BlockColor(rawValue:Int(arc4random_uniform(NumberOfColors)))!
    }
    
}

//#7 Class definition of Block whicht implements Hashable and CustomStringConvertible

class Block: Hashable, CustomStringConvertible{
    
    //#8 defining the block color as a let means that once we've assigned it, it can no longer be re-assigned.
    //Constants
    let color: BlockColor
    
    //#9 declaration of column and row as a location of a block
    //Properties
    var column: Int
    var row: Int
    var sprite: SKSpriteNode? // representation of visual element of a block
    
    //#10 providing a shortcut for recovering the sprite's file name
    var spriteName: String{
        return color.spriteName
    }
    
    //#11 implementation of hashValue calculated property which Hashable requires us to provide
    var hashValue: Int{
        return self.column ^ self.row
    }
    
    //#12 implementation of description \( and ) contain CustomStringConvertible object types
    var description: String{
        return"\(color):[\(column),\(row)]"
    }
    
    init(column:Int, row:Int, color:BlockColor){
        self.column = column
        self.row = row
        self.color = color
    }
}

//#13 custom operator == is being created, when we compare one Block to another. returns true, if both Blocks are in the same location and of the same color

func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}











