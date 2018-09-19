//
//  ViewController.swift
//  deliveries
//
//  Created by KamyFC on 17/09/18.
//  Copyright © 2018 KamyFC. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //How many items to get from server
    var offSetCounter : Int = 0
    //No more items to get from server
    var serverLimitReached : Bool = false
    //Caches the list of delivery items
    var deliveryList:[Delivery] = []
    //Service API
    var serviceAPI = BackEndService()
    //Progress Bar indicator shown in right bar button
    var activityIndicator = UIActivityIndicatorView()
    //Internet check service
    let recheabilityService = Reachability()
    //Error Button shown in left bar
    var refreshBarButton: UIBarButtonItem?
    //Error message shown during errors
    var errorLabel = UILabel()
    
    init(collectionViewLayout: UICollectionViewFlowLayout) {
        super.init(collectionViewLayout: collectionViewLayout)
        
        self.collectionView = collectionView
        self.offSetCounter = 0
        self.deliveryList = []
        self.serviceAPI = BackEndService()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activityIndicator.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        
        
        activityIndicator.tag = 0
        serverLimitReached = false
        navigationItem.title = "Things to Deliver"
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(DeliveryCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        errorLabel.text = "Network Connection Issue. Please try again."
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.textColor = UIColor.black
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.isHidden = true
        view.addSubview(errorLabel)

        view.addConstraint(NSLayoutConstraint(item: errorLabel, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: errorLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute:.leading, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: errorLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: errorLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 50))
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Lets get deliveries on load, shall we!
        self.getDeliveryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
  
    }
    
    
    
    //MARK:- Private Methods
    
    //Method that invokes methods in BackEndService class to get delivery data
    @objc func getDeliveryData()
    {
        if (serverLimitReached == false)
        {
            //Get data only of server has items
            
            if recheabilityService.isConnectedToNetwork() == true {
                errorLabel.isHidden = true
                self.navigationItem.leftBarButtonItem = nil
                print("Internet connection OK")
                activityIndicator.startAnimating()
                activityIndicator.tag = 1
                print("Getting Data from server for OFFSET - : \(offSetCounter)\n")
                serviceAPI.getDeliveryResults(offSet: offSetCounter) { (deliveryItems, error) in
                    if (error == "")
                    {
                        if ((deliveryItems?.count)! > 0)
                        {
                            for item in deliveryItems! as [Delivery]
                            {
                                self.deliveryList.append(item)
                            }
                            self.collectionView?.reloadData()
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.tag = 0
                        }
                        else
                        {
                            //Server will return 0 items then there are no more records to fetch.
                            
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.tag = 0
                            self.serverLimitReached = true
                            print("Server limit reached")
                        }
                    }
                    else
                    {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.tag = 0
                        self.showErrorMessage(error: "Other Error. Please try again.")
                    }
                }
            }
            else
            {
                print("Internet connection FAILED")
                showErrorMessage(error: "Network Connection Issue. Please try again.")
            }
        }
    }
    
    //Method to show errors during issues
    func showErrorMessage(error:String)
    {
        errorLabel.text = error
        errorLabel.isHidden = false
        
        refreshBarButton = UIBarButtonItem(title: "Try Again", style: .plain, target: self, action: #selector(self.getDeliveryData))
        
        self.navigationItem.setLeftBarButton(refreshBarButton, animated: true)
    }

    //MARK:- UICollectionView Callbacks
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deliveryList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! DeliveryCell
        
        let item = self.deliveryList[indexPath.row] as Delivery
        cell.deliveryItem = item
        cell.populateData()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:view.frame.width, height:260)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Lets how the detail view
        
        let item = self.deliveryList[indexPath.row] as Delivery
        
        let viewController = DeliveryDetailsViewController()
        viewController.deliveryItem = item
        viewController.view.backgroundColor = .white
        navigationController?.pushViewController(viewController, animated: true)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height {
            if (self.activityIndicator.tag == 0)
            {
                if recheabilityService.isConnectedToNetwork() == true {
                    //Enables Infinite Scrolling
                    offSetCounter += 20
                    self.getDeliveryData()
                }
                else
                {
                    print("Internet connection FAILED")
                    showErrorMessage(error: "Network Connection Issue. Please try again.")
                }
            }
        }
    }
    
}

