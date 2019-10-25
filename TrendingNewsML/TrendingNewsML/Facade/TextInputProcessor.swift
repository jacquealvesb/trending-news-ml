//
//  MLModel.swift
//  TrendingNewsML
//
//  Created by Manuella Valença on 08/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import Foundation
import CoreML

class TextInputProcessor {
    static let shared = TextInputProcessor()
    var vocabulary = [String: Int]()
    var idf = [Double]()
    
    init() {
        loadVocabulary()
        loadIdf()
    }
    
    // Load vocabulary of the model from words_array.json file
    // Vocabulary file needs to be created at the same time the model was trained
    func loadVocabulary() {
        let path = Bundle.main.url(forResource: "words_array", withExtension: "json")
        do {
            let wordsData = try Data(contentsOf: path!)
            if let wordsDict = try JSONSerialization.jsonObject(with: wordsData, options: []) as? [String: Int] {
                self.vocabulary = wordsDict
            }
        } catch {
            fatalError("Couldn't load words_array.json")
        }
    }
    
    // Load idf (inverse document frequency) of each world from the corpus trained in the model
    // Also needs to be created at the same time the model was trained
    func loadIdf(){
        let path = Bundle.main.url(forResource: "words_idf", withExtension: "json")
        do {
            let idfData = try Data(contentsOf: path!)
            if let idfJson = try JSONSerialization.jsonObject(with: idfData, options: []) as? [String: [Double]] {
                self.idf = idfJson["idf"]!
            }
        } catch {
            fatalError("Couldn't load words_idf.json")
        }
    }
    
    // Remove symbols and split the text into an array of words
    func tokenizer(_ text: String) -> [String] {
        let newText = text.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"))
        let tokens = newText.components(separatedBy: CharacterSet.whitespaces)
        return tokens
    }
    
    // Creates a dictionary to represent the sentence.
    // Each keys is a number that represents a word of the vocabulary.
    // The value is the number os times the word appeared in the sentence.
    func countVectorizer(sentence: String) -> [Int: Int]? {
        var vector = [Int: Int]()
        for word in self.tokenizer(sentence) {
            if let position = self.vocabulary[word] {
                if let index = vector[position] {
                    vector[position] = index + 1
                } else {
                    vector[position] = 1
                }
            }
        }
        return vector
    }
    
    // Check inverse document frequency of word, if this word is not in the corpus, returns 0.0
    func idf(word: String) -> Double {
        if let position = self.vocabulary[word] {
            return self.idf[position]
        } else {
            return Double(0.0)
        }
    }
    
    func makeTfidf(sentence: String) -> [Int: Double] {
        let cv = countVectorizer(sentence: sentence)
        var vector = [Int: Double]()
        cv?.forEach({ (key, value) in
            let wordIdf = self.idf[key]
            let tfidfWord = (Double(value) / Double(cv!.count)) * wordIdf
            vector[key] = tfidfWord
        })
        let tfidfSentence = normalize(vector: vector)
        return tfidfSentence
    }
    
    // Uses L2Normalization as the TFIDFVectorizer of model training used this as well
    func normalize(vector: [Int:Double]) -> [Int: Double] {
        // Uses flatmap in $1 (all the values)
        var sum = vector.flatMap{ $1 }.reduce(0) { $0 + $1*$1 }
        sum = sqrt(sum)
        var newVector = [Int:Double]()
        vector.forEach({ (key, value) in
            newVector[key] = value / sum
        })
        return newVector
    }
    
    // Transform String into MLMultiArray.
    // This is necessary to make a prediction for the MLModel, as it asks for an input parameter with MLMultiarray type.
    func makeMLMultiarray(from text: String) -> MLMultiArray? {
        let vector = makeTfidf(sentence: text)
        let mlmultiarray = try? MLMultiArray(shape: [NSNumber(integerLiteral: self.vocabulary.count)], dataType: .int32)
        for (key, value) in vector {
            mlmultiarray?[key] = NSNumber(value: value)
        }
        return mlmultiarray
    }
}
