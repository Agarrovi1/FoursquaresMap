//
//  FourSquaresAPIClient.swift
//  FoursquaresMap
//
//  Created by Angela Garrovillas on 11/4/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
class FourSquaresAPIClient {
    private init() {}
    static let manager = FourSquaresAPIClient()
    
    func getVenues(lat: Double, long: Double,query: String,completionHandler: @escaping (Result<[Venues],AppError>) -> ()) {
        let urlString = Secrets.makeUrlString(lat: lat, long: long, query: query)
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let venuesFromJSON = try JSONDecoder().decode(FourSquareVenues.self, from: data)
                    completionHandler(.success(venuesFromJSON.response.venues))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
    func getPhotoInfo(id: String,completionHandler: @escaping (Result<[ItemWrapper],AppError>) -> ()) {
        let urlString = Secrets.makePhotoUrlString(id: id)
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let photoInfoFromJSON = try JSONDecoder().decode(VenuePhotos.self, from: data)
                    completionHandler(.success(photoInfoFromJSON.response.photos.items))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
}
