//
//  Reciplease.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 23/08/2023.
//

import Foundation

struct Reciplease {
    let from: Int
    let to: Int
    let count: Int
    let links: [String: String] // "_links" est un objet JSON vide, donc nous utilisons un dictionnaire vide ici.
    let hits: [Any] // "hits" est un tableau JSON vide, donc nous utilisons un tableau vide ici.
}
