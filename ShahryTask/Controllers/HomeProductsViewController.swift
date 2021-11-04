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
    
    let skeletonTemplateCellCount = 6
    private var searchActive = false
    private var allProductsData : [ProductModel] = []
    private var filteredData:[ProductModel] = []
    private var searchResults:[ProductModel] = []
    var viewMode:ViewMode = .grid
    var sortingType:SortType?
    private var limit = 6
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    fileprivate func configureUIElements() {
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = UIColor.white
        sortTextField.delegate = self
        setupPickerView(forTextField: sortTextField)
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.isSkeletonable = true
        productsCollectionView.showAnimatedSkeleton()
        getProducts()
        
    }
    
    func getProducts(){
        ProductsServices.sharedInstance.getProducts(limit:limit) { success, returnedProductsData in
            if success{
                self.allProductsData = returnedProductsData!
                self.sort()
                self.productsCollectionView.reloadData()
                self.productsCollectionView.hideSkeleton()
            }
        }
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
        
        //cancel search when sorting to avoid data conflict
        searchActive = false
        searchBar.text = ""
        productsCollectionView.reloadData()
    }
    
    
}
extension HomeProductsViewController:UICollectionViewDelegate,UICollectionViewDataSource,SkeletonCollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "product"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count == 0 ? skeletonTemplateCellCount:(searchActive ? searchResults.count: filteredData.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = (viewMode == .grid) ? "product":"productRow"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ProductCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.isSkeletonable = true
        if filteredData.count > 0{
            let product = searchActive ? searchResults[indexPath.row]: filteredData[indexPath.row]
            cell.configureCell(productData: product)
        }
        return cell
        
    }
    
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (filteredData.count == 0) ? skeletonTemplateCellCount:(searchActive ? searchResults.count: filteredData.count)
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        
        let identifier = (viewMode == .grid) ? "product":"productRow"
        guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ProductCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.isSkeletonable = true
        if filteredData.count > 0{
            let product = searchActive ? searchResults[indexPath.row]: filteredData[indexPath.row]
            cell.configureCell(productData: product)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //adjust cell size based on view mode
        return (viewMode == .grid) ? CGSize(width: collectionView.frame.width/2 - 20, height: collectionView.frame.height/2.5)
        :
        CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.height/5)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let product = searchActive ? searchResults[indexPath.row]: filteredData[indexPath.row]
        let productDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "details") as! ProductDetailsViewController
        productDetails.product = product
        self.navigationController?.pushViewController(productDetails, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
        return footerView
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        //disable spinner when pagination ends
        if limit >= ProductsServices.PAGINATION_LIMIT || searchActive{
            return CGSize(width:0,height:0)
        }else{
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
    
    //detect scrolling to bottom
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        //this was added to fix pagination not working on smaller screen sizes due to floating point percision
        let deltaHeight = scrollContentSizeHeight - (scrollOffset + scrollViewHeight)
        print(deltaHeight)
        if (deltaHeight <= 0.25 && deltaHeight >= -0.25)
        {
            // then we are at the end
            if limit < ProductsServices.PAGINATION_LIMIT{
                limit+=4
                getProducts()
            }
        }
    }
}
extension HomeProductsViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title:String?
        if row == 0{
            title = "Default"
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
extension HomeProductsViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            searchActive = false
        }else{
            searchActive = true
            let unifiedSearchText = searchText.lowercased()
            searchResults = filteredData.filter{
                return $0.title!.lowercased().starts(with: unifiedSearchText)
            }
        }
        productsCollectionView.reloadData()
    }
}
