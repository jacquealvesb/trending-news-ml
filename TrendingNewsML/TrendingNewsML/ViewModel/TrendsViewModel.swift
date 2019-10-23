//
//  TrendsViewModel.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 18/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import Foundation
import Combine

class TrendsViewModel: ObservableObject {
    @Published var trendingWords: [String] = [String]()
    @Published var fetching: Bool = false
    
    init() {}
    
    init(count: Int, ofCategory category: Category) {
//        self.getWords(count: count, ofCategory: category)
    }
    
    /// Get n more common words in a list of top news from a category
    /// - Parameter count: Number of words to be get
    /// - Parameter category: Category of the top news
    private func getWords(count: Int, ofCategory category: Category) {
        self.fetching = true
        GNews.getArticles(of: category) { articles in
            let texts = articles.map { $0.text } // Get article texts
            var wordCount = self.wordCount(of: texts) // Get word count from the texts
            let stopwords = self.stopwords()
            wordCount = wordCount.filter { !stopwords.contains($0.key.lowercased()) } // Remove all stopwords from dictionary
            let sortedWords = wordCount.sorted { $0.1 > $1.1 } // Sort in ascending order according to count
            let firstN = sortedWords.prefix(count) // Get n more common words
            let firstNWords = firstN.map { String($0.key) } // Convert them to strings
            
            self.trendingWords.append(contentsOf: firstNWords)
            self.fetching = false
        }
    }
    
    /// Counts the number of times each word is found on the articles
    /// - Parameter articles: List of top news
    private func wordCount(of strings: [String]) -> [String.SubSequence: Int] {
        var wordCount: [String.SubSequence: Int] = [:]
        
        for string in strings {
            let words = string.split { !$0.isLetter } // Splits the words from the text removing spaces and punctuation
            let wordsNotRepeating = Set(words)
            for word in wordsNotRepeating { // Add to the dictionary the count of each word found
                if wordCount[word] == nil {
                    wordCount[word] = 0
                }
                
                wordCount[word]! += 1
            }
        }
        
        return wordCount
    }
    
    /// Get a list of stopwords present on a txt file
    private func stopwords() -> [String] {
        var stopwords = [String]()
        
        if let path = Bundle.main.path(forResource: "stopwords", ofType: "txt") {
            if let content = try? String(contentsOfFile: path) {
                let wordsSplit = content.split { !$0.isLetter }
                let words = wordsSplit.map { String($0) }
                
                stopwords.append(contentsOf: words)
            }
        }
        
        return stopwords
    }
}
