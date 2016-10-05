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
    
        let mapTitle = UILabel.init(frame: CGRect(x: 0.0, y: 0.0,width: 98.0 , height: 24.0))
    
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
        
        mapTitle.backgroundColor = UIColor.clear
        mapTitle.font = UIFont.systemFont(ofSize: 20.0)
        
        mapTitle.textAlignment = .center
        
        mapTitle.textColor = UIColor.white
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
        
        UserDefaults.standard.set(true, forKey: "mapSelected")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        delay(1.0) {
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.mapTitle)
        }
        
        guard let showStop = showStop else {return}
        
        
        let stopNumber = Int(showStop.stopNumber)
        let stopAnnotation = allStopAnnotations[stopNumber! - 1]
        map.selectAnnotation(stopAnnotation, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            return false
        case .restricted:
            return false
        case .denied:
            return false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        NSLog("did change authorization status")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
           
            map.showsUserLocation = true
            self.doThisWhenAuthorized?()
        default:
            break
        }
    }

    //MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
   
        guard let stopAnnotation = annotation as? StopAnnotation else {return nil}  // Make sure that when annotation for current user position is passed in there is no crash
        let pinView = MKPinAnnotationView()
        
        let stopNumber = stopAnnotation.stopNumber
        
        pinView.annotation = stopAnnotation
        pinView.pinTintColor = UIColor.green
        pinView.animatesDrop = true
        pinView.canShowCallout = true
        
        let firstStopPictureTitle = (allStops[stopNumber - 1].stopPictures[0])["picImage"]!
        let stopImageFileName = firstStopPictureTitle
        let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        
        StopsModel.resizeImage(fileName: stopImageFileName, type: "jpg", maxPointSize: 53) { (image) in
            leftImageView.image = image
            pinView.leftCalloutAccessoryView = leftImageView
        }
        
        
        let calloutButton = UIButton(type: .detailDisclosure)
        calloutButton.accessibilityLabel = "Shows details for this tour stop location"
        pinView.rightCalloutAccessoryView = calloutButton
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let stopAnnotation = view.annotation as! StopAnnotation
        
        
        annotationStopNumber = stopAnnotation.stopNumber
        
        performSegue(withIdentifier: "mapShowDetail", sender: self)

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // In a Regular horizontal size class the split view shows the map in the left pane
        // and the Stop detail in the right pane at the same time
        if splitViewController?.traitCollection.horizontalSizeClass == .regular {
            
            // Make sure this not from tapping the blue user location annotation
            guard let stopAnnotation = view.annotation as? StopAnnotation else {return}

            annotationStopNumber = stopAnnotation.stopNumber
            
            performSegue(withIdentifier: "mapShowDetail", sender: self)
        }
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapShowDetail" {
            
            let pageController = (segue.destination as! UINavigationController).topViewController as! MapPageViewController
            
            pageController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            pageController.navigationItem.leftItemsSupplementBackButton = true
            pageController.stop = allStops[annotationStopNumber - 1]
        }
    }

}
