//
//  Category.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 07/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import Foundation

enum Category: String, CaseIterable {
    case business = "Negócios"
    case entertainment = "Entretenimento"
    case health = "Saúde"
    case science = "Ciência"
    case sports = "Esportes"
    case technology = "Tecnologia"
    case world = "Mundo"
    case nation = "Nação"
}

extension Category {
    init(topic: String) {
        switch topic {
        case "business":
            self = .business
        case "entertainment":
            self = .entertainment
        case "health":
            self = .health
        case "science":
            self = .science
        case "sports":
            self = .sports
        case "technology":
            self = .technology
        default:
            self = .business
        }
    }
}
