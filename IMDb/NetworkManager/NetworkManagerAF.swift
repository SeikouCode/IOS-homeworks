//
//  NetworkManagerAFAF.swift
//  IMDb
//
//  Created by Aneli  on 18.01.2024.
//

import Foundation
import Alamofire

class NetworkManagerAF {
    
    // MARK: - Properties
    
    static let shared = NetworkManagerAF()
    private let baseURL: String = "https://api.themoviedb.org"
    private let apiKey: String = "e516e695b99f3043f08979ed2241b3db"

    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    func loadMovies(theme: String, completion: @escaping ([Result]) -> Void) {
        var components = urlComponents
        components.path = "/3/movie/\(theme)"
        
        guard let requestUrl = components.url else {
            return
        }
        
        AF.request(requestUrl).response { response in
            self.handleResponse(response, type: Movie.self) { movie in
                DispatchQueue.main.async {
                    completion(movie.results)
                }
            }
        }
    }

    func loadGenres(completion: @escaping ([Genre]) -> Void) {
        var components = urlComponents
        components.path = "/3/genre/movie/list"

        guard let requestUrl = components.url else {
            return
        }

        AF.request(requestUrl).response { response in
            self.handleResponse(response, type: GenresEntity.self) { (genresEntity: GenresEntity) in
                completion(genresEntity.genres)
            }
        }
    }

    func loadMovieDetails(id: Int, completion: @escaping (MovieDetailsEntity) -> Void) {
        var components = urlComponents
        components.path = "/3/movie/\(id)"

        guard let requestUrl = components.url else {
            return
        }

        AF.request(requestUrl).response { response in
            self.handleResponse(response, type: MovieDetailsEntity.self, completion: completion)
        }
    }

    func loadCast(movieId: Int, completion: @escaping ([CastElement]) -> Void) {
        var components = urlComponents
        components.path = "/3/movie/\(movieId)/credits"

        guard let requestUrl = components.url else {
            return
        }

        AF.request(requestUrl).response { response in
            self.handleResponse(response, type: CastEntity.self) { (castEntity: CastEntity) in
                completion(castEntity.cast)
            }
        }
    }

    func loadVideos(id: Int, completion: @escaping ([Video]) -> Void) {
        var components = urlComponents
        components.path = "/3/movie/\(id)/videos"

        guard let requestUrl = components.url else {
            return
        }

        AF.request(requestUrl).response { response in
            self.handleResponse(response, type: VideoEntity.self) { (videoEntity: VideoEntity) in
                completion(videoEntity.results)
            }
        }
    }
    
    func loadExternalIDs(actorId: Int, completion: @escaping (ExternalIDs) -> Void) {
        var components = urlComponents
        components.path = "/3/person/\(actorId)/external_ids"
        
        guard let requestUrl = components.url else {
            return
        }
        
        AF.request(requestUrl).responseDecodable(of: ExternalIDs.self) { response in
            switch response.result {
            case .success(let externalIDs):
                completion(externalIDs)
            case .failure(let error):
                print("Error loading external IDs: \(error)")
            }
        }
    }
    
    func loadActorDetails(actorId: Int, completion: @escaping (ActorDetailsModel) -> Void) {
        var components = urlComponents
        components.path = "/3/person/\(actorId)"
        
        guard let requestUrl = components.url else {
            return
        }
        
        AF.request(requestUrl).responseDecodable(of: ActorDetailsModel.self) { response in
            switch response.result {
            case .success(let actorDetails):
                completion(actorDetails)
            case .failure(let error):
                print("Error loading actor details: \(error)")
            }
        }
    }
    
    func loadActorPhotos(actorId: Int, completion: @escaping ([Profile]) -> Void) {
        var components = urlComponents
        components.path = "/3/person/\(actorId)/images"
        
        guard let requestUrl = components.url else {
            return
        }
        
        AF.request(requestUrl).responseDecodable(of: ActorPhotosResponse.self) { response in
            switch response.result {
            case .success(let actorPhotosResponse):
                completion(actorPhotosResponse.profiles)
            case .failure(let error):
                print("Error loading actor photos: \(error)")
                completion([])
            }
        }
    }
    
    func loadActorExternalIDs(actorId: Int, completion: @escaping (ExternalIDs?) -> Void) {
        var components = urlComponents
        components.path = "/3/person/\(actorId)/external_ids"
        
        guard let requestUrl = components.url else {
            return
        }
        
        AF.request(requestUrl).responseDecodable(of: ExternalIDs.self) { response in
            switch response.result {
            case .success(let externalIDs):
                completion(externalIDs)
            case .failure(let error):
                print("Error loading external IDs: \(error)")
                completion(nil)
            }
        }
    }
    
    private func loadActorMovies(actorId: Int) {
        NetworkManagerAF.shared.loadMovies(theme: "actor-\(actorId)") { [weak self] movies in

        }
    }

    
    // MARK: - Private Methods
    
    private func handleResponse<T: Decodable>(_ response: AFDataResponse<Data?>, type: T.Type, completion: @escaping (T) -> Void) {
        guard let data = response.data else {
            print("Error: Did not receive data")
            return
        }

        do {
            let decodedObject = try JSONDecoder().decode(type, from: data)
            DispatchQueue.main.async {
                completion(decodedObject)
            }
        } catch {
            DispatchQueue.main.async {
                print("Error decoding JSON: \(error)")
            }
        }
    }

    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return components
    }
}
