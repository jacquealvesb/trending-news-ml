//
//  TendingWord.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 07/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import SwiftUI

struct TrendingWord: View {
    let word: String
    let color: Color
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(color)
                .frame(height: 100)
                .cornerRadius(20)
            Text(word)
                .padding(10)
                .foregroundColor(Color.white)
                .font(.title)
        }
    }
}

struct TendingWord_Previews: PreviewProvider {
    static var previews: some View {
        TrendingWord(word: "Oi", color: .black)
    }
}
