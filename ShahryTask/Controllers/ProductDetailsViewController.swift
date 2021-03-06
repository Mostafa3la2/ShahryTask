//
//  ProductDetailsViewController.swift
//  ShahryTask
//
//  Created by Mostafa Alaa on 03/11/2021.
//

import UIKit
import Cosmos
class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productRating: CosmosView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var product:ProductModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        productTitle.text = product!.title
        productPrice.text = "$\(product!.price!)"
        self.productRating.rating = Double(product!.rating?.rate ?? 0)
        productCategory.text = "Category: " + product!.category!
        productDescription.text = product!.descriptionField
        productImage.kf.setImage(with:URL(string:product!.image!))
        self.navigationItem.title = product?.title
        // Do any additional setup after loading the view.
    }
    



}
