//
//  DeliveryCell.swift
//  deliveries
//
//  Created by KamyFC on 17/09/18.
//  Copyright © 2018 KamyFC. All rights reserved.
//

import UIKit

class DeliveryCell: UICollectionViewCell {
    
    var deliveryItem = Delivery()
    let deliveryLabel = UILabel()
    let imageView = UIImageView()
    var downloadManager: DownloadManager { return .shared }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        deliveryItem = Delivery()
        setupViews()
    }
    
    func populateData()
    {
        deliveryLabel.text = "\(deliveryItem.description) at \(deliveryItem.address)"
        
        if (self.deliveryItem.image == nil)
        {
            print("\(deliveryItem.id) : Downloading \(deliveryItem.imageURL) at : \(deliveryItem.address)")
            
            //Download the image from server asyncronously
            downloadManager.retrieveImage(for: deliveryItem.imageURL) { image in
                DispatchQueue.main.async {
                    self.deliveryItem.image = image!
                    self.imageView.image = image
                    self.setNeedsLayout()
                }
            }
        }
        else
        {
            print("Uisng Cache")
            self.imageView.image = self.deliveryItem.image
            self.setNeedsLayout()
        }
    }
   
    private func setupViews()
    {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let placeholderImage = UIImage(named: "placeholder")
        imageView.image = placeholderImage
        addSubview(imageView)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.lightGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorView)
        
        deliveryLabel.numberOfLines = 0
        deliveryLabel.lineBreakMode = .byWordWrapping
        deliveryLabel.translatesAutoresizingMaskIntoConstraints = false
        deliveryLabel.text = ""
        addSubview(deliveryLabel)
        
        var allConstraints: [NSLayoutConstraint] = []
        
        //ImageView Horizontal Constraint
        let horizontalImageConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[v0]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imageView])
        //Label Horizontal Constraint
        let labelHConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[v0]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : deliveryLabel])
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[v0]-6-[v1(50)]-6-[v2(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imageView, "v1" : deliveryLabel, "v2" : separatorView])
        //Separator Horizontal Constraint
        let separatorViewHConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : separatorView])
        
        allConstraints += horizontalImageConstraint
        allConstraints += separatorViewHConstraint
        allConstraints += verticalConstraints
        allConstraints += labelHConstraint

        addConstraints(allConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Coder not implemented")
    }
}


extension NSLayoutConstraint {
    
    override open var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}
