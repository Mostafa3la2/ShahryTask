//
//  ProductModel.swift
//  ShahryTask
//
//  Created by Mostafa Alaa on 02/11/2021.
//

import Foundation

struct ProductModel : Codable {

        let category : String?
        let descriptionField : String?
        let id : Int?
        let image : String?
        let price : Float?
        let rating : ProductRating?
        let title : String?

        enum CodingKeys: String, CodingKey {
                case category = "category"
                case descriptionField = "description"
                case id = "id"
                case image = "image"
                case price = "price"
                case rating = "rating"
                case title = "title"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                category = try values.decodeIfPresent(String.self, forKey: .category)
                descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
                id = try values.decodeIfPresent(Int.self, forKey: .id)
                image = try values.decodeIfPresent(String.self, forKey: .image)
                price = try values.decodeIfPresent(Float.self, forKey: .price)
                rating = try values.decodeIfPresent(ProductRating.self, forKey: .rating)
                title = try values.decodeIfPresent(String.self, forKey: .title)
        }

}

struct ProductRating : Codable {

        let count : Int?
        let rate : Float?

        enum CodingKeys: String, CodingKey {
                case count = "count"
                case rate = "rate"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                count = try values.decodeIfPresent(Int.self, forKey: .count)
                rate = try values.decodeIfPresent(Float.self, forKey: .rate)
        }

}
