//
//  CategoriesList.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 07/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI
import Combine

struct CategoriesList: View {
    @Binding var selectedCategory: Category?
    @ObservedObject var largerText: LargerText
    
    let rows: [[Category]] = [[.business, .entertainment],
                              [.health, .science],
                              [.sports, .technology]]
    let columns: [[Category]] = [[.business, .health, .sports],
                                 [.entertainment, .science, .technology]]
    
    var body: some View {
        VStack {
            ForEach(rows, id: \.self) { row in
                Group {
                    if self.largerText.active {
                        VStack {
                            CategoriesListCell(selectedCategory: self.$selectedCategory, categories: row, largerTextIsActive: self.largerText.active)
                        }
                    } else {
                        HStack {
                            CategoriesListCell(selectedCategory: self.$selectedCategory, categories: row, largerTextIsActive: self.largerText.active)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 30)
        .onAppear {
            NotificationCenter.default.addObserver(self.largerText,
                                                   selector: #selector(self.largerText.onDidReceiveData(_:)),
                                                   name: UIContentSizeCategory.didChangeNotification,
                                                   object: nil)
        }
    }
}

struct CategoriesListCell: View {
    @Binding var selectedCategory: Category?
    
    let categories: [Category]
    let largerTextIsActive: Bool
    
    var body: some View {
        ForEach(categories, id: \.self) { category in
            NavigationLink(destination: CategoryTrends(category: category, largerTextIsActive: self.largerTextIsActive)) {
                CategoryView(category: category, selected: (self.selectedCategory == nil || self.selectedCategory == category), largerTextIsActive: self.largerTextIsActive)
            }.buttonStyle(PlainButtonStyle())
        }
    }
}

struct CategoriesList_Previews: PreviewProvider {
    @State private static var selectedCategory: Category?
    
    static var previews: some View {
        CategoriesList(selectedCategory: CategoriesList_Previews.$selectedCategory, largerText: LargerText())
    }
}
