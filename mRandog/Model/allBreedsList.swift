//
//  allBreedsList.swift
//  mRandog
//
//  Created by lindong on 1/10/22.
//

import Foundation
//receive message of list of all breeds
struct allBreedsList: Codable{
    let message: [String: [String]]
}
