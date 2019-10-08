//
//  MLModel.swift
//  TrendingNewsML
//
//  Created by Manuella Valença on 08/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import CoreML
import Foundation

class MlModel {
    let model = BrNewsCategoryV3()
    
    func makePrediction(news: String) -> String {
        let mlarray = TextInputProcessor.shared.makeMLMultiarray(from: news)
        do {
            let result = try model.prediction(newsText: mlarray!)
            print(result.category)
            return result.category
        } catch {
            print(error)
            return "Deu pobrema"
        }
    }
}
