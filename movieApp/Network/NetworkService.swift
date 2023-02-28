//
//  Network.swift
//  movieApp
//
//  Created by Ertürk Alan on 14.02.2023.
//

import Foundation

import Alamofire

class NetworkService {
    static let sharedInstance = NetworkService()
    
    typealias MovieCompletion = (MovieResponse) -> Void
    typealias GenreCompletion = (GenreResponse) -> Void
    typealias CastCompletion = (CastResponse) -> Void

    
    func fetchNowPlayingMovies(pageNumber: Int, completion: @escaping MovieCompletion) {
        let url = K.Api.baseUrl + K.Api.apiKey + "&page=\(pageNumber)"
        print(url)
        AF.request(url, method: .get, parameters: nil, headers: nil, interceptor: nil).response { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(MovieResponse.self, from: data!)
                    completion(jsonData)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func searchMovie(pageNumber: Int, searchText: String, completion: @escaping MovieCompletion) {
        let url = K.Api.searchUrl + K.Api.apiKey + K.Api.languageUrlQuery + "&page=\(pageNumber)" 
        let parameters = ["query": searchText]
        AF.request(url, method: .get, parameters: parameters, headers: nil, interceptor: nil).response { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(MovieResponse.self, from: data!)
                    completion(jsonData)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchGenres(completion: @escaping GenreCompletion) {
        let url = K.Api.genreUrl + K.Api.apiKey + K.Api.languageUrlQuery
        AF.request(url, method: .get, parameters: nil, headers: nil, interceptor: nil).response { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(GenreResponse.self, from: data!)
                    completion(jsonData)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getCast(movieId: Int, completion: @escaping CastCompletion) {
        let url = K.Api.castUrl + String(movieId) + "/credits?api_key=" + K.Api.apiKey + K.Api.languageUrlQuery
        print(url)
        AF.request(url, method: .get, parameters: nil, headers: nil, interceptor: nil).response { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(CastResponse.self, from: data!)
                    completion(jsonData)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
