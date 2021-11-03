//
//  ProductCollectionViewCell.swift
//  ShahryTask
//
//  Created by Mostafa Alaa on 02/11/2021.
//

import UIKit
import Cosmos
import SkeletonView
import Kingfisher
class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productRating: CosmosView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    

    func configureCell(productData:ProductModel){
        self.productRating.rating = Double(productData.rating?.rate ?? 0)
        self.productPrice.text = "$\(productData.price ?? 0)"
        self.productTitle.text = productData.title
        self.productImage.kf.setImage(with:URL(string:productData.image!))
    }
}
