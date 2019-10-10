//
//  GNews.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 10/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import Foundation

enum GNewsError: Error {
    case wrongURL
    case nonConvertableResponse
    case badRequest
    case unauthorized
    case tooManyRequests
    case internalServerError
    case serviceUnavailable
}

class GNews {
    
    /// Get top news from categories
    /// - Parameter category: Category to get top news of
    public static func getNews(fromCategory category: Category) -> [News] {
        var news: [News] = []
        let topic: String = GNews.getTopic(ofCategory: category)
        let url = "https://gnews.io/api/v3/topics/\(topic)?token=\(gnewsAPIKey)&lang=pt-BR&country=br"
        
        GNews.request(url: url) { (dict, error) in
            if error != nil {
                return
            }
            
            if let newsResponse = dict["articles"] as? [String: Any] {
                for acticle in newsResponse {
                    news.append(News())
                }
            }
        }
        
        return news
    }
    
    /// Returns the string referred to the topic of a category
    /// - Parameter category: Category to get topic from
    static func getTopic(ofCategory category: Category) -> String {
        var topic: String!
        
        switch category {
        case .business:
            topic = "business"
        case .entertainment:
            topic = "category"
        case .health:
            topic = "health"
        case .science:
            topic = "science"
        case .sports:
            topic = "sports"
        case .technology:
            topic = "science"
        }
        
        return topic
    }
    
    /// GET from url
    /// - Parameter url: URL to be requested
    /// - Parameter completionHandler: Handler that deals with the request response
    static func request(url: String, completionHandler: @escaping (_ dict: [String: Any], _ error: Error?) -> Void) {
        guard let requestURL = URL(string: url) else {
            completionHandler([:], GNewsError.wrongURL)
            return
        }
    
        let task = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if error != nil {
                completionHandler([:], error)
                return
            }
            
            if let data = data {
                do {
                    if let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completionHandler(result, nil)
                    } else {
                        completionHandler([:], GNewsError.nonConvertableResponse)
                    }
                } catch {
                    completionHandler([:], GNewsError.wrongURL)
                }
            }
        }
        
        task.resume()
    }
}
