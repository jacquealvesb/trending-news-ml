//
//  AnaliseTextField.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 07/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI

struct AnaliseTextField: View {
    @Binding var textToAnalise: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 2)
                .padding(.bottom, 10)
            VStack(alignment: .leading) {
                Text("ANALISAR NOTÍCIA")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                TextField("Coloque o texto a ser analisado", text: $textToAnalise)
            }
            .padding()
        }
    }
}

struct AnaliseTextField_Previews: PreviewProvider {
    @State private static var textToAnalise: String = ""
    
    static var previews: some View {
        AnaliseTextField(textToAnalise: AnaliseTextField_Previews.$textToAnalise)
    }
}
