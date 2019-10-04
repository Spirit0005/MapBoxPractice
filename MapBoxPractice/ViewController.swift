//
//  ViewController.swift
//  MapBoxPractice
//
//  Created by 2 Minut on 10/2/19.
//  Copyright © 2019 2 Minut. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

class ViewController: UIViewController,MGLMapViewDelegate {

    var directionsRoute:Route?
    
    @IBOutlet  var mapView: NavigationMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
      
        // Do any additional setup after loading the view.
    }

    
//---- function to create route
    
    func calculateRoute(from originCoor:CLLocationCoordinate2D, to destinationCoor:CLLocationCoordinate2D, completion: @escaping (Route? , Error?) -> Void){
        
    //----- defining start and end points
        
        let origin = Waypoint(coordinate: originCoor, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destinationCoor, coordinateAccuracy: -1, name: "Finish")
    // --- defining route options
        
        let options = NavigationRouteOptions(waypoints: [origin,destination], profileIdentifier: .automobileAvoidingTraffic)
     
    //------ placing the cordinates on the map and settign the camera and zoom
        
        _ = Directions.shared.calculate(options, completionHandler: { (waypoints, route, error) in
            
            self.directionsRoute = route?.first
          //--- draw line
            self.drawRoute(route: self.directionsRoute!)
            
            let cordinateBounds = MGLCoordinateBounds(sw: destinationCoor, ne: originCoor)
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            let routeCam = self.mapView.cameraThatFitsCoordinateBounds(cordinateBounds, edgePadding: insets)
            self.mapView.setCamera(routeCam, animated: true)
        })
    }
    
    
//------ functin to draw line on the map
    func drawRoute(route:Route){
        
        //---- check to see if the cordinate is valid
        guard route.coordinateCount > 0 else{return}
        
        var routeCordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCordinates, count: route.coordinateCount)
        
        if let source = mapView.style?.source(withIdentifier: "route_source") as? MGLShapeSource{
            source.shape = polyline
        }else{
            
            let source = MGLShapeSource(identifier: "route_source", features: [polyline], options: nil)
            let lineStlye = MGLLineStyleLayer(identifier: "route_style", source: source)
            lineStlye.lineColor = NSExpression(forConstantValue: UIColor.blue)
            lineStlye.lineWidth = NSExpression(forConstantValue: 4.0)
            
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStlye)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


