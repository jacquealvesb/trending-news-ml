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
                    AnaliseTextField(textToAnalise: $textToAnalise)
                    HStack(alignment: .center) {
                        Spacer()
                        Button(action: analyseButtonAction) {
                            Text("Analisar")
                                .padding(.vertical, 5)
                                .padding(.horizontal, 20)
                                .foregroundColor(Color.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                                
                        }.onTapGesture(perform: analyse)
                        Spacer()
                    }
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
    
    func analyse() {
        print("analisar")
    }
    
    func analyseButtonAction() {
        print("Make haptic and sound feedback")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
