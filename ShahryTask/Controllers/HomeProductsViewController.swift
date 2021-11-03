//
//  HomeProductsViewController.swift
//  ShahryTask
//
//  Created by Mostafa Alaa on 02/11/2021.
//

import UIKit
import SkeletonView
import SwiftUI

enum ViewMode{
    case grid
    case list
}
enum SortType:String,CaseIterable{
    static var asArray: [SortType] {return self.allCases}

    case priceAsc = "Price Ascending ↑"
    case priceDesc = "Price Descending ↓"
    case ratingAsc = "Rating Ascending ↑"
    case ratingDesc = "Rating Descending ↓"
}

class HomeProductsViewController: UIViewController {
    
    @IBOutlet weak var sortTextField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    private var allProductsData : [ProductModel] = []
    private var filteredData:[ProductModel] = []
    let refreshControl = UIRefreshControl()
    var viewMode:ViewMode = .grid
    var sortingType:SortType?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchTextField.backgroundColor = UIColor.white
        sortTextField.delegate = self
        setupPickerView(forTextField: sortTextField)
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.isSkeletonable = true
        productsCollectionView.showAnimatedSkeleton()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        //productsCollectionView.refreshControl = refreshControl // not re

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ProductsServices.sharedInstance.getProducts { success, returnedProductsData in
            if success{
                self.allProductsData = returnedProductsData!
                self.filteredData = self.allProductsData
                self.productsCollectionView.reloadData()
                self.productsCollectionView.hideSkeleton()
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
    }
    
    @IBAction func toggleViewModeButton(_ sender: UIButton) {
        if viewMode == .grid{
            viewMode = .list
            sender.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        }else{
            viewMode = .grid
            sender.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        }
        productsCollectionView.reloadData()
    }
    
    private func setupPickerView(forTextField textField:UITextField){
        let pickerView = UIPickerView()
        pickerView.setValue(UIColor.white, forKey: "backgroundColor")
        pickerView.delegate = self
        pickerView.tag = textField.tag
        textField.inputView = pickerView
        
    }
    
    private func sort(){
        switch sortingType{
        case .priceAsc:
            sortTextField.text = "💲↑"
            filteredData = allProductsData.sorted(by: { productOne, productTwo in
                return productOne.price! < productTwo.price!
            })
        case .priceDesc:
            sortTextField.text = "💲↓"
            filteredData = allProductsData.sorted(by: { productOne, productTwo in
                return productOne.price! > productTwo.price!
            })
        case .ratingAsc:
            sortTextField.text = "⭐️↑"
            filteredData = allProductsData.sorted(by: { productOne, productTwo in
                return productOne.rating!.rate! < productTwo.rating!.rate!
            })
        case .ratingDesc:
            sortTextField.text = "⭐️↓"
            filteredData = allProductsData.sorted(by: { productOne, productTwo in
                return productOne.rating!.rate! > productTwo.rating!.rate!
            })
        default:
            sortTextField.text = ""
            filteredData = allProductsData
        }
        productsCollectionView.reloadData()
    }
    
    
}
extension HomeProductsViewController:UICollectionViewDelegate,UICollectionViewDataSource,SkeletonCollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "product"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = (viewMode == .grid) ? "product":"productRow"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ProductCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.isSkeletonable = true
        if filteredData.count > 0{
            let product = filteredData[indexPath.row]
            cell.configureCell(productData: product)
        }
        return cell
        
    }
    
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        let identifier = (viewMode == .grid) ? "product":"productRow"
        guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ProductCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.isSkeletonable = true
        if filteredData.count > 0{
            let product = filteredData[indexPath.row]
            cell.configureCell(productData: product)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (viewMode == .grid) ? CGSize(width: collectionView.frame.width/2 - 20, height: collectionView.frame.height/2.5)
        :
        CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height/5)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
}
extension HomeProductsViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title:String?
        if row == 0{
            title = "Select Sort Type"
        }else{
            title = SortType.asArray[row-1].rawValue
        }
        let attributedString = NSAttributedString(string: title!, attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica Neue", size: 12)!,NSAttributedString.Key.foregroundColor : UIColor.systemTeal])
        return attributedString
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 0{
            sortingType = SortType.asArray[row-1]
            
        }else{
            sortingType = nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
 
        return 5
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
extension HomeProductsViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        sort()
    }
}
