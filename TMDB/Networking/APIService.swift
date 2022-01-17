//
//  APIService.swift
//  TMDB
//
//  Created by BS236 on 13/1/22.
//

import Foundation

class APIService {
    static let API = APIService()
    
    public func getGenreList(completionHandler: @escaping (GenreResponse)-> Void){
        let task = URLSession.shared.dataTask(with: URL(string: Constants.genreURL)!, completionHandler: {
            (data, response, error) in
            
            var result: GenreResponse?
            do {
                result = try JSONDecoder().decode(GenreResponse.self, from: data!)
                guard let json = result else {
                    return
                }
                completionHandler(json)
                
            } catch {
                print(error)
            }
            
        })
        
        task.resume()
    }
    
    public func getMoviesByGenre(_ id: Int, completionHandler: @escaping (MovieCollectionResponse)->Void){
        let task = URLSession.shared.dataTask(with: URL(string: Constants.getMovieCollectionURL(byGenre: id ))!, completionHandler: {
            (data, response, error) in
            
            var result: MovieCollectionResponse?
            do {
                result = try JSONDecoder().decode(MovieCollectionResponse.self, from: data!)
                guard let json = result else {
                    return
                }
                
                completionHandler(json)
            } catch {
                print(error)
            }
            
        })
        
        task.resume()
    }
    
    public func getMoviePoster(_ posterPath: String, completionHandler: @escaping (Data)->Void) {
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: Constants.posterBaseURL + posterPath)!)) {
            (data, req, error) in
            guard let posterData = data else {
                print("poster data not found")
                return
            }
            completionHandler(posterData)

        }.resume()
    }
}