//
//  ContentView.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 03/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var textToAnalyse: String = ""
    @State private var selectedCategory: Category?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Section(header: SectionHeader(title: "Analisar")) {
                        AnalyseTextField(textToAnalyse: $textToAnalyse)
                        HStack(alignment: .center) {
                            Spacer()
                            AnalyseButton()
                            Spacer()
                        }
                    }
                    .padding(.horizontal)

                    Section(header: SectionHeader(title: "Categorias")) {
                        CategoriesList(selectedCategory: $selectedCategory, largerText: LargerText())
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitle("Notícias")
            .listStyle(GroupedListStyle())
            .padding(.top)
            .onAppear {
                UITableView.appearance().separatorColor = .clear
                UITableView.appearance().backgroundColor = .clear
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
