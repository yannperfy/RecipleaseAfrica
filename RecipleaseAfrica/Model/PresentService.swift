//
//  RecipleaseService.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 23/08/2023.
//

import Foundation
class PresentService {
    
    
    static let shared = PresentService()
    private init() {}
    
    
    private(set) var presents: [Present] = []
    
    
    func add(present: Present) {
        presents.append(present)
    }
    
    func remove(at index: Int) {
        presents.remove(at: index)
    }
    
}
