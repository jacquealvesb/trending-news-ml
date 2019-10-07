//
//  CategoryView.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 07/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    static let colors: [Category: Color] = [.business: Color.blue,
                                            .entertainment: Color.pink,
                                            .health: Color.red,
                                            .science: Color.green,
                                            .sports: Color.orange,
                                            .technology: Color.purple]
    static let icons: [Category: String] = [.business: "briefcase.fill",
                                           .entertainment: "tv",
                                           .health: "heart.fill",
                                           .science: "ant.circle",
                                           .sports: "sportscourt.fill",
                                           .technology: "globe"]
    
    let category: Category
    let selected: Bool
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(Self.colors[category, default: .black])
                .frame(height: 120)
                .cornerRadius(20)
            VStack(alignment: .leading) {
                Image(systemName: Self.icons[category, default: "questionmarl.circle"])
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                    .foregroundColor(Color.white)
                    .font(.headline)
                Spacer()
                Text(category.rawValue)
                    .padding(10)
                    .foregroundColor(Color.white)
                    .font(.headline)
            }
        }
        .opacity(selected ? 1 : 0.3)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: .business, selected: true)
    }
}
