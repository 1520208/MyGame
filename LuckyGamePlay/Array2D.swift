//
//  Array2D.swift
//  LuckyGamePlay
//
//  Created by Jacqueline on 23.05.17.
//  Copyright © 2017 Jackys Code Factory. All rights reserved.
//


//#1 Define class Array2D as a generic array. Generic Arrays in Swift are structs.
//The <T> allows our array to store any data type and remain a general-purpose tool


class Array2D<T> {
    
    let columns: Int
    
    let rows: Int
    
//#2 the ? after <T> means the value is optional, it may/may not contain data, it may in fact be nil or empty
    
    var array: Array<T?>
    
    init(columns: Int, rows: Int){
        self.columns = columns
        self.rows = rows
        
//#3 Initialization, we instantiate our array structure with a size of rows X columns
        
        array = Array<T?>(repeating: nil, count: rows * columns)
        
    }
    
//#4 we create a custom subscript for Array2D
    //get: which value has a given location?
    //set: the location shall have the newValue
    
    subscript(column: Int, row: Int) -> T?{
        get{
            return array[(row * columns) + column]
        }
        set(newValue){
            array[(row * columns) + column] = newValue
            
        }
    }
    
}
