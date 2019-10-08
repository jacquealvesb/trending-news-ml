//
//  MLModel.swift
//  TrendingNewsML
//
//  Created by Manuella Valença on 08/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import Foundation
import CoreML

class InputProcessor {
    var vocabulary = [String:Int]()
    
    func loadVocabulary() {
        let path = Bundle.main.url(forResource:"words_array", withExtension:"json")
        do {
            let wordsData = try Data(contentsOf: path!)
            if let wordsDict = try JSONSerialization.jsonObject(with: wordsData, options: []) as? [String:Int] {
                self.vocabulary = wordsDict
                print(self.vocabulary.count)
            }
        } catch {
            fatalError("Couldn't load words_array.json")
        }
    }
    
    func makeMLMultiarray(from text: String) -> MLMultiArray {
        let vector = countVectorizer(sentence: text)
        let mlmultiarray = try! MLMultiArray(shape: [NSNumber(integerLiteral: self.vocabulary.count)], dataType: .int32)
        for (key, value) in vector! {
            mlmultiarray[key] = NSNumber(value: value)
        }
        return mlmultiarray
    }
    
    func countVectorizer(sentence: String) -> [Int:Int]? {
        var vector = [Int:Int]()
        for word in self.tokenizer(sentence) {
            if let position = self.vocabulary[word] {
                if let i = vector[position] {
                    vector[position] = i + 1
                } else {
                    vector[position] = 1
                }
            }
        }
        return vector
    }
    
    func tokenizer(_ text: String) -> [String] {
        let newText = text.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"))
        let tokens = newText.components(separatedBy: CharacterSet.whitespaces)
        return tokens
    }
}
