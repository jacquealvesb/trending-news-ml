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
    let largerTextIsActive: Bool
    
    @Binding var selectedCategory: Category?
    
    var body: some View {
        List {
            Text(category.rawValue)
                .font(self.largerTextIsActive ? .headline : .largeTitle)
                .fontWeight(.bold)
                .listRowBackground(Color(UIColor.systemBackground))
            
            ForEach(trendingWords, id: \.self) { word in
                TrendingWord(word: word, color: CategoryView.colors[self.category, default: .black], largerTextIsActive: self.largerTextIsActive)
            }
            .listRowBackground(Color(UIColor.systemBackground))
        }
        .navigationBarTitle("Temas do momento", displayMode: .inline)
        .onAppear {
            UITableView.appearance().separatorColor = UIColor.systemBackground
            self.selectedCategory = nil
        }
    }
}

struct CategoryTrends_Previews: PreviewProvider {
    @State private static var selectedCategory: Category?
    
    static var previews: some View {
        CategoryTrends(category: .business, largerTextIsActive: false, selectedCategory: CategoryTrends_Previews.$selectedCategory)
    }
}
