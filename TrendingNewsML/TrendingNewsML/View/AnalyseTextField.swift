//
//  AnalyseTextField.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 07/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI

struct AnalyseTextField: View {
    @Binding var textToAnalyse: String
    @ObservedObject var largerText: LargerText
    let action: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 2)
            VStack(alignment: .leading) {
                Text(self.largerText.active ? "ANALISAR\nNOTÍCIA" : "ANALISAR NOTÍCIA")
                    .accessibility(label: Text("Analisar notícia"))
                    .font(.caption)
                    .foregroundColor(Color.gray)
                HStack {
                    TextField("URL", text: $textToAnalyse, onCommit: action)
                        .padding(.vertical, 5)
                    if self.textToAnalyse != "" {
                        Button(action: self.clearText) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color.gray.opacity(0.4))
                        }
                    }
                }
            }
            .padding()
        }
        .padding(.bottom)
    }
    
    func clearText() {
        self.textToAnalyse = ""
    }
}

struct AnalyseTextField_Previews: PreviewProvider {
    @State private static var textToAnalyse: String = ""
    
    static var previews: some View {
        AnalyseTextField(textToAnalyse: AnalyseTextField_Previews.$textToAnalyse, largerText: LargerText()) {
            print("analisar")
        }
    }
}
