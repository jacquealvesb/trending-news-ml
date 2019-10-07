//
//  ContentView.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 03/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var textToAnalise: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: SectionHeader(title: "Analisar")) {
                    TextField("Text to analise", text: $textToAnalise)
                }

                Section(header: SectionHeader(title: "Categorias")) {
                    CategoriesList()
                }
            }
            .navigationBarTitle("Notícias")
            .padding(.top)
            .listStyle(GroupedListStyle())
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
