//
//  CategoryTrends.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 07/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI

struct CategoryTrends: View {
    @State private var trendingWords: [String] = ["Oi", "Tudo", "Bem", "Com", "Você"]
    
    let category: Category
    
    var body: some View {
        List {
            ForEach(trendingWords, id: \.self) { word in
                TrendingWord(word: word, color: CategoryView.colors[self.category, default: .black])
            }
            .listRowBackground(Color(UIColor.systemBackground))
        }
        .navigationBarTitle(category.rawValue)
    }
}

struct CategoryTrends_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTrends(category: .business)
    }
}
