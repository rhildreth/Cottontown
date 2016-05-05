//
//  MapViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 12/28/15.
//  Copyright © 2015 Tappdev.com. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
        let mapTitle = UILabel.init(frame: CGRectMake(0.0, 0.0,98.0 , 24.0))
    
    let allStops = StopsModel.sharedInstance.allStops
    var allStopAnnotations = [StopAnnotation]()
    var annotationStopNumber = 0
    
    var showStop: Stop?
    
    let cottontownLoc = CLLocationCoordinate2DMake(34.019176, -81.038619)
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    var doThisWhenAuthorized : (() -> ())?
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapTitle.backgroundColor = UIColor.clearColor()
        mapTitle.font = UIFont.systemFontOfSize(20.0)
        
        mapTitle.textAlignment = .Center
        
        mapTitle.textColor = UIColor.whiteColor()
        mapTitle.text = "Cottontown Historic District"
        mapTitle.accessibilityLabel = "Map of the Cottontown Historic District.  Map pins show tour stop locations.  Double tap pins for more details"
        
        mapTitle.sizeToFit()
        navigationItem.titleView = mapTitle
        mapTitle.isAccessibilityElement = true
        
        map.delegate = self
      
        
        
        
        allStopAnnotations = createStopAnnotations()
        self.map.addAnnotations(allStopAnnotations)
        map.showAnnotations(allStopAnnotations, animated: true)
        map.showsCompass = true
        map.showsScale = true
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "mapSelected")

    }
    
    override func viewWillAppear(animated: Bool) {
        
        delay(1.0) {
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.mapTitle)
        }
        
        guard let showStop = showStop else {return}
        
        
        let stopNumber = Int(showStop.stopNumber)
        let stopAnnotation = allStopAnnotations[stopNumber! - 1]
        map.selectAnnotation(stopAnnotation, animated: false)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if determineStatus() {
            map.showsUserLocation = true
        } else {
            map.showsUserLocation = false
//            NSLog("Location Services not available")
        }
    }
    
    func createStopAnnotations () -> [StopAnnotation] {
        for stop in allStops {
            let stopNumber = Int(stop.stopNumber)!
            let latitude = Double(stop.latitude)!
            let longitude = Double(stop.longitude)!
            let cood = CLLocationCoordinate2DMake(latitude, longitude)
            allStopAnnotations.append(StopAnnotation(coordinate: cood, title: stop.stopTitle, subtitle: stop.stopAddress, stopNumber: stopNumber))
        }
        return allStopAnnotations
    }
    
    func determineStatus() -> Bool {
      
        guard CLLocationManager.locationServicesEnabled() else {
            return false
        }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            return true
        case .NotDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            return false
        case .Restricted:
            return false
        case .Denied:
            return false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        NSLog("did change authorization status")
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
           
            map.showsUserLocation = true
            self.doThisWhenAuthorized?()
        default:
            break
        }
    }

    //MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
   
        guard let stopAnnotation = annotation as? StopAnnotation else {return nil}  // Make sure that when annotation for current user position is passed in there is no crash
        let pinView = MKPinAnnotationView()
        
        let stopNumber = stopAnnotation.stopNumber
        
        pinView.annotation = stopAnnotation
        pinView.pinTintColor = UIColor.greenColor()
        pinView.animatesDrop = true
        pinView.canShowCallout = true
        
        let firstStopPictureTitle = (allStops[stopNumber - 1].stopPictures[0])["picImage"]!
        let stopImageFileName = firstStopPictureTitle
        let leftImageView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
        
        StopsModel.resizeImage(fileName: stopImageFileName, type: "jpg", maxPointSize: 53) { (image) in
            leftImageView.image = image
            pinView.leftCalloutAccessoryView = leftImageView
        }
        
        
        let calloutButton = UIButton(type: .DetailDisclosure)
        calloutButton.accessibilityLabel = "Shows details for this tour stop location"
        pinView.rightCalloutAccessoryView = calloutButton
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let stopAnnotation = view.annotation as! StopAnnotation
        
        
        annotationStopNumber = stopAnnotation.stopNumber
        
        performSegueWithIdentifier("mapShowDetail", sender: self)

    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        // In a Regular horizontal size class the split view shows the map in the left pane
        // and the Stop detail in the right pane at the same time
        if splitViewController?.traitCollection.horizontalSizeClass == .Regular {
            
            // Make sure this not from tapping the blue user location annotation
            guard let stopAnnotation = view.annotation as? StopAnnotation else {return}

            annotationStopNumber = stopAnnotation.stopNumber
            
            performSegueWithIdentifier("mapShowDetail", sender: self)
        }
 
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapShowDetail" {
            
            let pageController = (segue.destinationViewController as! UINavigationController).topViewController as! MapPageViewController
            
            pageController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            pageController.navigationItem.leftItemsSupplementBackButton = true
            pageController.stop = allStops[annotationStopNumber - 1]
        }
    }

}
