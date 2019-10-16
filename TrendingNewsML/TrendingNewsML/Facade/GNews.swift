//
//  GNews.swift
//  TrendingNewsML
//
//  Created by Jacqueline Alves on 10/10/19.
//  Copyright © 2019 maqueline. All rights reserved.
//

import Foundation
import ReadabilityKit

enum GNewsError: Error {
    case wrongURL
    case nonConvertableResponse
    case textNotFound
    case badRequest
    case unauthorized
    case tooManyRequests
    case internalServerError
    case serviceUnavailable
}

class GNews {
    
    /// Get top news from categories
    /// - Parameter category: Category to get top news of
    /// - Parameter completionHandler: Handler that deals with the list of articles returned
    public static func getArticles(of category: Category, completionHandler: @escaping (_ article: [Article]) -> Void) {
        let topic: String = GNews.getTopic(ofCategory: category)
        let url = "https://gnews.io/api/v3/topics/\(topic)?token=\(gnewsAPIKey)&lang=pt-BR&country=br&max=100"
        
        GNews.request(url: url) { (dict, error) in
            if error != nil {
                return
            }
                        
            if let newsResponse = dict["articles"] as? [[String: Any]] {
                let urls = newsResponse.map { $0["url"] as? String ?? "" } // Gets the list of urls of the requested articles
                
                GNews.extractArticles(from: urls) { articles in // Extract the articles from the urls
                    completionHandler(articles)
                }
            }
        }
        
    }
    
    /// Returns the string referred to the topic of a category
    /// - Parameter category: Category to get topic from
    private static func getTopic(ofCategory category: Category) -> String {
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
        case .world:
            topic = "world"
        case .nation:
            topic = "nation"
        }
        
        return topic
    }
    
    /// GET from url
    /// - Parameter url: URL to be requested
    /// - Parameter completionHandler: Handler that deals with the request response
    private static func request(url: String, completionHandler: @escaping (_ dict: [String: Any], _ error: Error?) -> Void) {
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
    
    /// Gets the list of articles from the urls
    /// - Parameter urls: List of URLs to extract articles
    /// - Parameter completionHandler: Handler that deals with the response of the parsers
    private static func extractArticles(from urls: [String], completionHandler: @escaping (_ article: [Article]) -> Void) {
        var articles: [Article] = []
        let dispatchGroup = DispatchGroup() // Make a dispatch group to only leave functions when all articles are parsed
        
        for url in urls { // Steps through all urls
            dispatchGroup.enter()
            
            GNews.extractArticle(from: url) { (article, error) in // Trys to extract the article from the url
                if error != nil {
                    dispatchGroup.leave()
                }
                
                if let article = article {
                    articles.append(article) // Appends the extracted acticle to the articles list
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completionHandler(articles)
        }
    }
    
    /// Extracts an article from an url page
    /// - Parameter url: URL from the article to be extracted
    /// - Parameter completionHandler: Handler that deals with the response of the parser
    private static func extractArticle(from url: String, completionHandler: @escaping (_ article: Article?, _ error: Error?) -> Void) {
        guard let articleUrl = URL(string: url) else { // Checks if the given url is correct
            completionHandler(nil, GNewsError.wrongURL)
            return
        }
        
        Readability.parse(url: articleUrl, completion: { data in // Gets the content from the url and parses it to an article
            if let data = data {
                let title = data.title
                let description = data.description ?? ""
                guard let text = data.text else { // Checks if the text from the article was found
                    completionHandler(nil, GNewsError.textNotFound)
                    return
                }

                let article = Article(title: title, description: description, text: text)
                
                completionHandler(article, nil)
                
            } else {
                completionHandler(nil, GNewsError.nonConvertableResponse)
            }
        })
    }
}
