//
//  DogAPI.swift
//  mRandog
//
//  Created by lindong on 1/8/22.
//

import Foundation
import UIKit
class DogAPI{
    enum Endpoint{
        //an API returns random images from dog api
        case randomImageFromAllDogsCollection
        //return random images depending on breed
        case randomImageForBreed(String)
        //the list with all breeds
        case listAllBreeds
        
        var url: URL{
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String{
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    //request list with all the breeds
    class func requestAllBreeds(completionHandler: @escaping([String]?, Error?) -> Void){
        let listEndpoint = DogAPI.Endpoint.listAllBreeds.url
        let task = URLSession.shared.dataTask(with: listEndpoint) { data, response, error in
            guard let data = data else {
                print("no data from request all breeds")
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do{
                let listData = try decoder.decode(allBreedsList.self, from: data)
                let breeds = listData.message.keys.map({$0})
                completionHandler(breeds, nil)
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
    
    //request an image based on url
    class func requestImageFile(url: URL, completionHandler: @escaping(UIImage?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else{
                completionHandler(nil, error)
                return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        }
        task.resume()
    }
    
    //request an random image url
    class func requestRandomImage(breed: String,completionHandler: @escaping (DogImage?, Error?) -> Void){
        let randomImageEndpoint = DogAPI.Endpoint.randomImageForBreed(breed).url
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return}
            let decoder = JSONDecoder()
            do{
                let imageData = try decoder.decode(DogImage.self, from: data)
                completionHandler(imageData, nil)
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
        
}
