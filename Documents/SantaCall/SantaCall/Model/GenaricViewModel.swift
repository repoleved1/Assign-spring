//
//  GenaricViewModel.swift
//  SantaCall
//
//  Created by Feitan on 11/9/20.
//

import Foundation

protocol IndexReturnable {
    associatedtype Object
    var itemsForSelection : [Object] { get set }
    func getItem(at index: Int) -> Object
}

struct GenericViewModel<T>: IndexReturnable {

    var itemsForSelection: [T]
    
    init(items: [T]) {
        self.itemsForSelection = items
    }
    
    func getItem(at index: Int) -> T {
        return self.itemsForSelection[index]
    }
    
    mutating func update(items: [T]) {
        self.itemsForSelection.removeAll()
        self.itemsForSelection = items
    }
}
