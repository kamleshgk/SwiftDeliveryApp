//
//  DeliveryDetailsViewController.swift
//  deliveries
//
//  Created by KamyFC on 19/09/18.
//  Copyright © 2018 KamyFC. All rights reserved.
//

import UIKit
import MapKit

class DeliveryDetailsViewController: UIViewController {
    
    var deliveryItem: Delivery?
    var deliveryLabel: UILabel? = nil
    var imageView:UIImageView? = nil
    var mapView:MKMapView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Delivery Details"
        
        self.deliveryLabel = UILabel()
        self.imageView = UIImageView()
        
        self.mapView = MKMapView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 400))
        self.mapView?.mapType = MKMapType.standard
        self.mapView?.isZoomEnabled = true
        self.mapView?.isScrollEnabled = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: (deliveryItem?.latitude)!, longitude: (deliveryItem?.longitude)!)
        self.mapView?.addAnnotation(annotation)
        
        view.addSubview(self.mapView!)
        
        self.mapView?.showAnnotations((self.mapView?.annotations)!, animated: true)
        
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.image = deliveryItem?.image
        view.addSubview(imageView!)
        
        deliveryLabel?.numberOfLines = 0
        deliveryLabel?.lineBreakMode = .byWordWrapping
        deliveryLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        var deliveryText: String = ""
        
        if let description = deliveryItem?.description {
            if let address = deliveryItem?.address {
                deliveryText = "\(description) at \(address)"
            }
        }
        
        deliveryLabel?.text = deliveryText
        view.addSubview(deliveryLabel!)
        
        
        view.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .top, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute:.leading, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 50))
        view.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 50))
        
        view.addConstraint(NSLayoutConstraint(item: deliveryLabel!, attribute: .top, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: deliveryLabel!, attribute: .leading, relatedBy: .equal, toItem: imageView!, attribute:.trailing, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: deliveryLabel!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: deliveryLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 50))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
