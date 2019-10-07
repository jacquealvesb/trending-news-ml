//
//  CategoriesList.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 07/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI

struct CategoriesList: View {
    @Binding var selectedCategory: Category?
    
    let rows: [[Category]] = [[.business, .entertainment],
                              [.health, .science],
                              [.sports, .technology]]
    let columns: [[Category]] = [[.business, .health, .sports],
                                 [.entertainment, .science, .technology]]
    
    var body: some View {
        VStack {
            ForEach(rows, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { category in
                        NavigationLink(destination: CategoryTrends(category: category)) {
                            CategoryView(category: category, selected: (self.selectedCategory == nil || self.selectedCategory == category))
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding(.bottom, 30)
    }
}

struct CategoriesList_Previews: PreviewProvider {
    @State private static var selectedCategory: Category?
    
    static var previews: some View {
        CategoriesList(selectedCategory: CategoriesList_Previews.$selectedCategory)
    }
}
