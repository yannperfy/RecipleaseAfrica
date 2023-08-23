//
//  RecipleaseService.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 23/08/2023.
//

import Foundation
class RecipleaseService {
    
    
    static let shared = RecipleaseService()
    private init() {}
    
    
    private(set) var recipleases: [Reciplease] = []
    
    
    func add(reciplease: Reciplease) {
        recipleases.append(reciplease)
    }
    
}
