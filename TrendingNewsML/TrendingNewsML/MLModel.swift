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
    
    // Requests a prediction from the model with the news article text as a MLMultiarray
    func makePrediction(news: String) -> String {
        let mlarray = TextInputProcessor.shared.makeMLMultiarray(from: news)
        do {
            let result = try model.prediction(newsText: mlarray!)
            print(result.category)
            return result.category
        } catch {
            print(error)
            return "Error: Prediction of the model couldn't be requested."
        }
    }
}
