//
//  FeaturedCollectionViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 19/4/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import SwiftSpinner

private var reuseIdentifier = "Cell"

class FeaturedCollectionViewController: UICollectionViewController {
    
    
    @IBOutlet var FeaturedCollectionView: UICollectionView!
    
    var ref: FIRDatabaseReference!
    var productsHandle: FIRDatabaseHandle!
    
    //3 product lists for 3 sections in collection view
    var allProducts: [Product] = []
    var newProducts: [Product] = []
    var dailyProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        //add all products to web database
        //addToServer()
        
        FeaturedCollectionView.dataSource = self
        FeaturedCollectionView.delegate = self
        
        //download all products from server and update it when it's changed in server
        addProductData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //get all new products from firebase
    //and download new product or update product when new data add in server, remove product when server delete it
    func addProductData(){
        //download all products
        //https://firebase.google.com/docs/database/ios/lists-of-data
        let refProducts = ref.child("Products")
        productsHandle = refProducts.observe(.childAdded, with: { (snapshot) in
            let productObject = snapshot.value as! [String: AnyObject]
            let name = productObject["name"] as! String
            let price = productObject["price"] as! Double
            let species = productObject["species"] as! String
            let productDes = productObject["productDes"] as! String
            let newArrival = productObject["newArrival"] as! Bool
            let dailySpecial = productObject["dailySpecial"] as! Bool
            let newProduct = Product(name: name, price: price, species: species, productDes: productDes, newArrival: newArrival, dailySpecial: dailySpecial )
            newProduct.amount = 1.0
            self.allProducts.append(newProduct)
            if newProduct.newArrival == true{
                self.newProducts.append(newProduct)
            }
            if newProduct.dailySpecial == true{
                self.dailyProducts.append(newProduct)
            }
            self.FeaturedCollectionView.reloadData()

        })
        
        //update product when it's updated in server
        productsHandle = refProducts.observe(.childChanged, with: { (snapshot) in
            let productObject = snapshot.value as! [String: AnyObject]
            let name = productObject["name"] as! String
            let price = productObject["price"] as! Double
            let species = productObject["species"] as! String
            let productDes = productObject["productDes"] as! String
            let newArrival = productObject["newArrival"] as! Bool
            let dailySpecial = productObject["dailySpecial"] as! Bool
            for i in self.allProducts{
                if i.name == name{
                    i.price = price
                    i.species = species
                    i.productDes = productDes
                    i.newArrival = newArrival
                    i.dailySpecial = dailySpecial
                }
            }
            //change daily special and new arrival group
            self.newProducts.removeAll()
            self.dailyProducts.removeAll()
            for i in self.allProducts{
                if i.newArrival == true{
                    self.newProducts.append(i)
                }
                if i.dailySpecial == true{
                    self.dailyProducts.append(i)
                }
            }
            self.FeaturedCollectionView.reloadData()
        })
        
        //delete product when is removed from server
        productsHandle = refProducts.observe(.childRemoved
            , with: { (snapshot) in
            let productObject = snapshot.value as! [String: AnyObject]
            let name = productObject["name"] as! String
            for i in self.allProducts{
                if i.name == name{
                    let index = self.allProducts.index(of: i)
                    self.allProducts.remove(at: index!)
                    if i.newArrival == true{
                        let newIndex = self.newProducts.index(of: i)
                        self.newProducts.remove(at: newIndex!)
                    }
                    if i.dailySpecial == true{
                        let specialIndex = self.dailyProducts.index(of: i)
                        self.dailyProducts.remove(at: specialIndex!)
                    }
                }
            }
            self.FeaturedCollectionView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //return 3 sections in collection view
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    //assign number of rows based on different sections
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (section){
        case 0:
            return newProducts.count
        case 1: return dailyProducts.count
        case 2: return allProducts.count
        default: return 0
        }
    }

    //create information of each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //in new arrival section
        if indexPath.section == 0{
            reuseIdentifier = "NewArrivalCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewArrivalCell", for: indexPath) as! ProductFeaturedCell
            let product: Product = self.newProducts[indexPath.row]
            cell.productImage.image = UIImage(named: product.name!)
            cell.productName.text = product.name
            cell.productPrice.text = "$ \(String(product.price!))"
            //assignment for button tag in selected cell
            cell.addButton.tag = indexPath.row
            //add taget for the add button in first section
            cell.addButton.addTarget(self, action: #selector(self.addProductNew), for: .touchUpInside)
            cell.productImage.layer.borderWidth = 0.7
            cell.productImage.layer.borderColor = UIColor.orange.cgColor.copy(alpha: 0.7)
            return cell
        }
        //in daily special section
        else if indexPath.section == 1{
            reuseIdentifier = "DailySpecialCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailySpecialCell", for: indexPath) as! ProductFeaturedCell
            let product: Product = self.dailyProducts[indexPath.row]
            cell.productImage.image = UIImage(named: product.name!)
            cell.productName.text = product.name
            cell.productPrice.text = "$ \(String(product.price!))"
            cell.addButton.tag = indexPath.row
            //add taget for the add button in second section
            cell.addButton.addTarget(self, action: #selector(self.addProductSpecial), for: .touchUpInside)
            cell.productImage.layer.borderWidth = 0.7
            cell.productImage.layer.borderColor = UIColor.orange.cgColor.copy(alpha: 0.7)
            return cell
        } 
        //in all products section
        else{
            reuseIdentifier = "AllProductsCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllProductsCell", for: indexPath) as! ProductFeaturedCell
            let product: Product = self.allProducts[indexPath.row]
            cell.productImage.image = UIImage(named: product.name!)
            cell.productName.text = product.name
            cell.productPrice.text = "$ \(String(product.price!))"
            cell.addButton.tag = indexPath.row
            //add taget for the add button in last section
            cell.addButton.addTarget(self, action: #selector(self.addProductAll), for: .touchUpInside)
            cell.productImage.layer.borderWidth = 0.7
            cell.productImage.layer.borderColor = UIColor.orange.cgColor.copy(alpha: 0.7)
            return cell
        }
    }
    
    //set the section headers
    //https://www.raywenderlich.com/136161/uicollectionview-tutorial-reusable-views-selection-reordering
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        //if the element kind is section header
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FeaturedHeaderView", for: indexPath) as! FeaturedHeaderView
            
            //finish downloading data
            if allProducts.count != 0{
                //set headers based on different sections
                switch indexPath.section{
                case 0:
                    headerView.headerLabel.text = "New Arrival"
                    headerView.headerLabel.textColor = UIColor.orange
                case 1:
                    headerView.headerLabel.text = "Daily Special"
                    headerView.headerLabel.textColor = UIColor.red
                case 2:
                    headerView.headerLabel.text = "All Product"
                    headerView.headerLabel.textColor = UIColor.darkGray
                default:
                    headerView.headerLabel.text = "Unknown"
                    headerView.headerLabel.textColor = UIColor.red
                }
                
                //remove the loading animation
                SwiftSpinner.hide()
                
            }
            else{
                //set the process animation
                headerView.headerLabel.text = ""
                SwiftSpinner.show("Loading products data")
            }
            return headerView
            
        //default warning for errors
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    //Using segue to pass selected product and switch to ProductDetail page
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let item = self.newProducts[indexPath.row]
            self.performSegue(withIdentifier: "PassingProductSegue", sender: item)
        }
        if indexPath.section == 1{
            let item = self.dailyProducts[indexPath.row]
            self.performSegue(withIdentifier: "PassingProductSegue", sender: item)
        }
        if indexPath.section == 2{
            let item = self.allProducts[indexPath.row]
            self.performSegue(withIdentifier: "PassingProductSegue", sender: item)
        }
    }
    
    // use segue identifier to pass selected product and store it in the ProductDetail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PassingProductSegue"{
            let destinationVC = segue.destination as! ProductDetailViewController
            destinationVC.currentProduct = (sender as? Product)!
        }
    }
    
    //3 buttons within the collection cell, a shortcut to open a popup to add products to basket
    //the button in the new arrival section
    func addProductNew(sender: UIButton) {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addProductPopup") as! addProductPopupViewController
        self.addChildViewController(popupVC)
        popupVC.view.frame = self.view.frame
        
        let product = newProducts[sender.tag]
        popupVC.currentProduct = product
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: self)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //the button in daily special section
    func addProductSpecial(sender: UIButton) {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addProductPopup") as! addProductPopupViewController
        self.addChildViewController(popupVC)
        popupVC.view.frame = self.view.frame
        let product = dailyProducts[sender.tag]
        popupVC.currentProduct = product
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: self)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //the button in all products section
    func addProductAll(sender: UIButton) {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addProductPopup") as! addProductPopupViewController
        self.addChildViewController(popupVC)
        popupVC.view.frame = self.view.frame
        let product = allProducts[sender.tag]
        popupVC.currentProduct = product
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: self)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //add default products to web database
    func addToServer(){
        ref.child("Products/1").setValue(["name": "Broccoli", "price": 2.5, "newArrival": false, "dailySpecial": true, "productDes": "This is a very healthy food in the world.", "species": "Fresh Vegetable"])
        ref.child("Products/2").setValue(["name": "NesCafe", "price": 6.5, "newArrival": false, "dailySpecial": false, "productDes": "This is a basic instant coffee in NesCafe.", "species": "Instant Coffee"])
        ref.child("Products/3").setValue(["name": "Pink Lady", "price": 1.5, "newArrival": false, "dailySpecial": true, "productDes": "This is the most common red apple in Australia.", "species": "Fresh Friut"])
        ref.child("Products/4").setValue(["name": "Olive Oil", "price": 4.5, "newArrival": false, "dailySpecial": false, "productDes": "This is a very common oli.", "species": "Oil"])
        ref.child("Products/5").setValue(["name": "A2 Milk", "price": 4.5, "newArrival": false, "dailySpecial": true, "productDes": "This is the most popular fresh milk in coles.", "species": "Fresh Milk"])
        ref.child("Products/6").setValue(["name": "Western Butter", "price": 3.5, "newArrival": true, "dailySpecial": true, "productDes": "This is a original butter in western star.", "species": "Butter"])
        ref.child("Products/7").setValue(["name": "Cookies Ice Cream", "price": 5.5, "newArrival": true, "dailySpecial": false, "productDes": "This is a very tasty ice cream in coles.", "species": "Ice Cream"])
        ref.child("Products/8").setValue(["name": "Cola", "price": 2.2, "newArrival": false, "dailySpecial": true, "productDes": "This is a very tasty and most popular beverage in the world.", "species": "Beverage"])
        ref.child("Products/9").setValue(["name": "Orange", "price": 1.8, "newArrival": true, "dailySpecial": false, "productDes": "This is a very fresh fruit in coles.", "species": "Fruit"])
        ref.child("Products/10").setValue(["name": "Laji Noodles", "price": 2.5, "newArrival": true, "dailySpecial": false, "productDes": "This is a very very spicy noodles, you cen get an excited experience.", "species": "Instant Noodles"])
        ref.child("Products/11").setValue(["name": "Nutella", "price": 3.5, "newArrival": true, "dailySpecial": false, "productDes": "It's very suitable for eating bread in the morning", "species": "Chotolate Sauce"])
        ref.child("Products/12").setValue(["name": "Hello Panda", "price": 3.5, "newArrival": false, "dailySpecial": true, "productDes": "Hello Panda is a brand of Japanese biscuit, each consists of a small hollow shortbread layer.", "species": "Snack"])
        ref.child("Products/13").setValue(["name": "Pocky", "price": 3.3, "newArrival": false, "dailySpecial": false, "productDes": "Pocky is a very popular treat in Japan, especially among teenagers.", "species": "Snack"])
        ref.child("Products/14").setValue(["name": "Choco Pie", "price": 1.5, "newArrival": false, "dailySpecial": false, "productDes": "A choco pie is a snack cake consisting of two small round layers of cake with marshmallow filling with chocolate covering.", "species": "Pie"])
        ref.child("Products/15").setValue(["name": "White Rabbit Candy", "price": 4.5, "newArrival": false, "dailySpecial": false, "productDes": "White Rabbit Creamy Candy is a brand of milk candy manufactured by Shanghai Guan Sheng Yuan Food.", "species": "Candy"])
        ref.child("Products/16").setValue(["name": "Koala's March", "price": 6.5, "newArrival": false, "dailySpecial": false, "productDes": "Koala's March is a bite-sized cookie snack with a sweet filling.", "species": "Cookie"])
        ref.child("Products/17").setValue(["name": "Haw Flakes", "price": 5.5, "newArrival": false, "dailySpecial": false, "productDes": "Haw Flakes are Chinese sweets made from the fruit of the Chinese hawthorn.", "species": "Candy"])
        ref.child("Products/18").setValue(["name": "Yakult", "price": 1.5, "newArrival": false, "dailySpecial": false, "productDes": "Yakult is a probiotic dairy product made by fermenting a mixture of skimmed milk with a special strain of the bacterium Lactobacillus casei Shirota.", "species": "Beverage"])
        ref.child("Products/19").setValue(["name": "Singapore Curry", "price": 4.5, "newArrival": true, "dailySpecial": false, "productDes": "If you love curry as much as I do, you have to try this one. It comes with a pair of flavor packets.", "species": "Instant noodles"])
        ref.child("Products/20").setValue(["name": "Sinkiang Black Beer", "price": 3.5, "newArrival": false, "dailySpecial": false, "productDes": "It has a strong flavor with a hint of brown sugar-like sweetness, like an American dark lager.", "species": "Beer"])
        ref.child("Products/21").setValue(["name": "C100", "price": 3.5, "newArrival": false, "dailySpecial": false, "productDes": "From lemon to grapefruit flavors, the vitamin-rich drink has a tangy, sweet and acidic lemonade taste.", "species": "Beer"])
        ref.child("Products/22").setValue(["name": "Tsingtao beer", "price": 4.5, "newArrival": true, "dailySpecial": true, "productDes": "The most recognized Chinese beer in the world, Tsingtao is sold in 62 countries and region.", "species": "Beer"])
        ref.child("Products/23").setValue(["name": "Wahaha Nutri-Express", "price": 2.5, "newArrival": true, "dailySpecial": false, "productDes": "Comparable to what liquid Skittles might taste like, this drink is a mix of fruit juice and milk.", "species": "Beverage"])
        ref.child("Products/24").setValue(["name": "Cooling tea", "price": 2.5, "newArrival": true, "dailySpecial": false, "productDes": "This herbal tea's history dates to the Qing dynasty.", "species": "Tea"])
        ref.child("Products/25").setValue(["name": "Paldo Budae Jigae Ramyun", "price": 3.5, "newArrival": false, "dailySpecial": false, "productDes": "The Koreans added the hot dogs, cheese, luncheon loafd, pork and beans and macaroni to a traditional soup ", "species": "Instant noodles"])
        ref.child("Products/26").setValue(["name": "Jacobs", "price": 10.5, "newArrival": false, "dailySpecial": false, "productDes": "Jacobs  is a brand of coffee that traces its beginnings to 1895 in Germany.", "species": "Instant coffee"])
        ref.child("Products/27").setValue(["name": "Banana", "price": 2.5, "newArrival": false, "dailySpecial": false, "productDes": "The banana is an edible fruit – botanically a berry – produced by several kinds of large herbaceous flowering plants in the genus Musa.", "species": "Fruit"])
        ref.child("Products/28").setValue(["name": "Strawberry", "price": 1.5, "newArrival": false, "dailySpecial": false, "productDes": "The garden strawberry is a widely grown hybrid species of the genus Fragaria It is cultivated worldwide for its fruit.", "species": "Fruit"])
        ref.child("Products/29").setValue(["name": "Lemon", "price": 0.9, "newArrival": false, "dailySpecial": false, "productDes": "Lemon is a species of small evergreen tree in the flowering plant family Rutaceae, native to Asia.", "species": "Fruit"])
        ref.child("Products/30").setValue(["name": "Watermelon", "price": 1.9, "newArrival": false, "dailySpecial": false, "productDes": "Watermelon is a scrambling and trailing vine in the flowering plant family Cucurbitaceae.", "species": "Fruit"])
    }

}
