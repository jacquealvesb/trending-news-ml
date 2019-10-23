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
    @State private var showingAlert: Bool = false
    @State private var loading: Bool = false
    
    var errorAlertConfiguration: (title: String, message: String) = ("Aconteceu alguma coisa de errado.", "Tente novamente.")
    
    let largerTextObserver = LargerText()
    let generator = UINotificationFeedbackGenerator()
    
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
                        ZStack {
                            CategoriesList(selectedCategory: $selectedCategory, largerText: largerTextObserver)
                                .opacity(self.loading ? 0 : 1)
                            
                            VStack {
                                ActivityIndicator(isAnimating: $loading, style: .large)
                                Text("ANALISANDO")
                                    .font(.caption)
                                    .foregroundColor(self.loading ? Color.gray : Color.clear)
                            }
                        }
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
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(self.errorAlertConfiguration.title),
                      message: Text(self.errorAlertConfiguration.message),
                      dismissButton: .default(Text("Ok"), action: {
                        self.textToAnalyse = ""
                        self.selectedCategory = nil
                      }))
            }
        }
    }
    
    func analyze() {
        self.loading = true
        GNews.extractArticle(from: self.textToAnalyse) { (article, error) in // Extracts the text from thr url
            self.generator.notificationOccurred(.success) // Haptic feedback
            self.loading = false // Remove activity indicator
            self.textToAnalyse = "" // Clear text field
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Hide keyboard
            
            if let error = error {
                print(error)
                self.generator.notificationOccurred(.error)
                self.showingAlert = true
                return
            }
            
            if let article = article {
                let topic = MlModel.shared.makePrediction(news: article.text) // Predicts from which category the news is
                
                if topic == "" {
                    self.generator.notificationOccurred(.error)
                    self.showingAlert = true
                } else {
                    self.selectedCategory = Category(topic: topic) // Updates the selected category
                }
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
