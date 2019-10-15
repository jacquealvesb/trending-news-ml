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
    
    let largerTextObserver = LargerText()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Section(header: SectionHeader(title: "Analisar")) {
                        AnalyseTextField(textToAnalyse: $textToAnalyse, largerText: largerTextObserver, action: analyze)
                        HStack(alignment: .center) {
                            Spacer()
                            AnalyseButton(action: analyze)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)

                    Section(header: SectionHeader(title: "Categorias")) {
                        CategoriesList(selectedCategory: $selectedCategory, largerText: largerTextObserver)
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
    
    func analyze() {
        GNews.extractArticle(from: self.textToAnalyse) { (article, error) in // Extracts the text from thr url
            if let error = error {
                print(error)
                return
            }
            
            if let article = article {
                let topic = MlModel.shared.makePrediction(news: article.text) // Predicts from which category the news is
                self.selectedCategory = Category(topic: topic) // Updates the selected category
            } else {
                return
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
