//
//  TrendsViewModel.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 18/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import Combine

class TrendsViewModel: ObservableObject {
    @Published var trendingWords: [String] = [String]()
    
    init() {}
    
    init(count: Int, ofCategory category: Category) {
        self.getWords(count: count, ofCategory: category)
    }
    
    /// Get n more common words in a list of top news from a category
    /// - Parameter count: Number of words to be get
    /// - Parameter category: Category of the top news
    private func getWords(count: Int, ofCategory category: Category) {
        GNews.getArticles(of: category) { articles in
            let wordCount = self.wordCount(of: articles) // Get word count from the articles
            let sortedWords = wordCount.sorted { $0.1 > $1.1 } // Sort in ascending order according to count
            let firstN = sortedWords.prefix(count) // Get n more common words
            let firstNWords = firstN.map { String($0.key) } // Convert them to strings
            
            self.trendingWords.append(contentsOf: firstNWords)
        }
    }
    
    /// Counts the number of times each word is found on the articles
    /// - Parameter articles: List of top news
    private func wordCount(of articles: [Article]) -> [String.SubSequence: Int] {
        var wordCount: [String.SubSequence: Int] = [:]
        
        for article in articles {
            let words = article.text.split { !$0.isLetter } // Splits the words from the text removing spaces and punctuation
            for word in words { // Add to the dictionary the count of each word found
                if wordCount[word] == nil {
                    wordCount[word] = 0
                }
                
                wordCount[word]! += 1
            }
        }
        
        return wordCount
    }
}
