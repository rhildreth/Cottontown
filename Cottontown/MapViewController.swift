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
    
    let allStops = StopsModel.sharedInstance.allStops
    var allStopAnnotations = [StopAnnotation]()
    
    let cottontownLoc = CLLocationCoordinate2DMake(34.019176, -81.038619)
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    var doThisWhenAuthorized : (() -> ())?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
      
        if determineStatus() {
            map.showsUserLocation = true
        } else {
            print("Location Services not available")
        }
        
        
        allStopAnnotations = createStopAnnotations()
        self.map.addAnnotations(allStopAnnotations)
        map.showAnnotations(allStopAnnotations, animated: true)
        map.showsCompass = true
        map.showsScale = true
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
//            let message = "Wouldn't you like to authorize" +
//            "this app to use Location Services?"
//            let alert = UIAlertController(title: "Need Authorization",
//                message: message, preferredStyle: .Alert)
//            alert.addAction(UIAlertAction(title: "No",
//                style: .Cancel, handler: nil))
//            alert.addAction(UIAlertAction(title: "OK",
//                style: .Default, handler: {
//                    _ in
//                    let url = NSURL(string:UIApplicationOpenSettingsURLString)!
//                    UIApplication.sharedApplication().openURL(url)
//            }))
//            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("did change authorization status: \(status)")
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            self.doThisWhenAuthorized?()
        default: break
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
        let stopImageFileName = firstStopPictureTitle + "_tn"
        let leftImageView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
        leftImageView.image = UIImage(named: stopImageFileName)
        pinView.leftCalloutAccessoryView = leftImageView
        
        let calloutButton = UIButton(type: .DetailDisclosure)
        pinView.rightCalloutAccessoryView = calloutButton
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let stopAnnotation = view.annotation as! StopAnnotation
        print("Stop Number:",stopAnnotation.stopNumber)
        
        let mapPageVC = MapPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil )
        mapPageVC.extendedLayoutIncludesOpaqueBars = false
        
        mapPageVC.stop = allStops[stopAnnotation.stopNumber - 1]
        let modeButton = self.splitViewController?.displayModeButtonItem()
        mapPageVC.navigationItem.leftBarButtonItem = modeButton
        mapPageVC.navigationItem.leftItemsSupplementBackButton = true
        
        let nav = UINavigationController(rootViewController: mapPageVC)
        
        self.showDetailViewController(nav , sender: self)

    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if splitViewController!.traitCollection.horizontalSizeClass == .Regular {
            let stopAnnotation = view.annotation as! StopAnnotation
            print("Stop Number:",stopAnnotation.stopNumber)
            
            let mapPageVC = MapPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil )
            mapPageVC.extendedLayoutIncludesOpaqueBars = false
            
            mapPageVC.stop = allStops[stopAnnotation.stopNumber - 1]
            let b = self.splitViewController?.displayModeButtonItem()
            mapPageVC.navigationItem.leftBarButtonItem = b
            mapPageVC.navigationItem.leftItemsSupplementBackButton = true
            
            let nav = UINavigationController(rootViewController: mapPageVC)
            
            self.showDetailViewController(nav , sender: self)

        }
    }

}
