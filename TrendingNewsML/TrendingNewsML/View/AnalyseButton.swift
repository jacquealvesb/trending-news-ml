//
//  AnalyseButton.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 07/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI

struct AnalyseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Analisar")
                .padding(.vertical, 5)
                .padding(.horizontal, 20)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(8)
                
        }
        .padding(.bottom, 30)
    }
}

struct AnalyseButton_Previews: PreviewProvider {
    static var previews: some View {
        AnalyseButton {
            print("press")
        }
    }
}
