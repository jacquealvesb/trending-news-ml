//
//  CategoriesList.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 07/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI

struct CategoriesList: View {
    let rows: [[Category]] = [[.business, .entertainment],
                              [.health, .science],
                              [.sports, .technology]]
    
    var body: some View {
        ForEach(rows, id: \.self) { row in
            HStack {
                ForEach(row, id: \.self) { category in
                    CategoryView(category: category)
                }
            }
        }
    }
}

struct CategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesList()
    }
}
