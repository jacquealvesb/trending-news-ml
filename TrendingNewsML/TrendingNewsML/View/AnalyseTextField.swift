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
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 2)
                .padding(.bottom, 10)
            VStack(alignment: .leading) {
                Text("ANALISAR NOTÍCIA")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                TextField("Coloque o texto a ser analisado", text: $textToAnalyse)
            }
            .padding()
        }
    }
}

struct AnalyseTextField_Previews: PreviewProvider {
    @State private static var textToAnalyse: String = ""
    
    static var previews: some View {
        AnalyseTextField(textToAnalyse: AnalyseTextField_Previews.$textToAnalyse)
    }
}
