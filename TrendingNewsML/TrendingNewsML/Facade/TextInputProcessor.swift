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
    
    init() {
        loadVocabulary()
    }
    
    // Load vocabulary of the model from words_array.json file
    // Vocabulary file needs to be created at the same time the model was trained
    func loadVocabulary() {
        let path = Bundle.main.url(forResource: "words_array", withExtension: "json")
        do {
            let wordsData = try Data(contentsOf: path!)
            if let wordsDict = try JSONSerialization.jsonObject(with: wordsData, options: []) as? [String: Int] {
                self.vocabulary = wordsDict
                print(self.vocabulary.count)
            }
        } catch {
            fatalError("Couldn't load words_array.json")
        }
    }
    
    // Transform String into MLMultiArray.
    // This is necessary to make a prediction for the MLModel, as it asks for an input parameter with MLMultiarray type.
    func makeMLMultiarray(from text: String) -> MLMultiArray? {
        let vector = countVectorizer(sentence: text)
        let mlmultiarray = try? MLMultiArray(shape: [NSNumber(integerLiteral: self.vocabulary.count)], dataType: .int32)
        for (key, value) in vector! {
            mlmultiarray?[key] = NSNumber(value: value)
        }
        return mlmultiarray
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
    
    // Remove symbols and split the text into an array of words
    func tokenizer(_ text: String) -> [String] {
        let newText = text.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"))
        let tokens = newText.components(separatedBy: CharacterSet.whitespaces)
        return tokens
    }
}
