//
//  CategoryTrends.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 07/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI
import Combine

struct CategoryTrends: View {
    @ObservedObject var viewModel: TrendsViewModel
    
    let category: Category
    let largerTextIsActive: Bool
    
    @Binding var selectedCategory: Category?
    
    init(category: Category, largerTextIsActive: Bool, selectedCategory: Binding<Category?>) {
        self.category = category
        self.largerTextIsActive = largerTextIsActive
        self._selectedCategory = selectedCategory
        self.viewModel = TrendsViewModel(count: 5, ofCategory: category)
    }
    
    var body: some View {
        ZStack {
            List {
                Text(category.rawValue)
                    .font(self.largerTextIsActive ? .headline : .largeTitle)
                    .fontWeight(.bold)
                    .listRowBackground(Color(UIColor.systemBackground))
                ForEach(viewModel.trendingWords, id: \.self) { word in
                    TrendingWord(word: word, color: CategoryView.colors[self.category, default: .black], largerTextIsActive: self.largerTextIsActive)
                }
                .listRowBackground(Color(UIColor.systemBackground))
            }
            VStack {
                ActivityIndicator(isAnimating: self.$viewModel.fetching, style: .large)
                Text("BUSCANDO")
                    .font(.caption)
                    .foregroundColor(self.viewModel.fetching ? Color.gray : Color.clear)
            }
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
