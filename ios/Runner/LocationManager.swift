//
//  LocationManager.swift
//  Runner
//
//  Created by kvn clvn on 1/23/23.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    static let shared = LocationManager()
    override init() {
        super.init()
        setUpLocation()
    }
    
    var driverId:String?
    var loadNumber: String?
    var tripId: String?
    var driverName: String?
    var batteryLevel: String?
    var url: String?
    var token: String?
    var companyCode: String?
    
    private var initialTime: Date?
    let defaults = UserDefaults.standard
    
    func setUpLocation()   {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.startUpdatingLocation()
    }
  
    func stopLocation() {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            if #available(iOS 9.0, *) {
                locationManager.allowsBackgroundLocationUpdates = true
            } else {
                // Fallback on earlier versions
            }
            print("..authorizedAlways")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            print("..authorizedWhenInUse")
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            print("..notDetermined")
        case .denied:
            locationManager.stopUpdatingLocation()
            print("..denied")
        default:
            locationManager.requestAlwaysAuthorization()
            print("..default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         
        if let location = locations.last {
            
            let time = location.timestamp
            
            guard let initialTime = initialTime else {
                self.initialTime = time
                return
            }
            
            let elapsed = time.timeIntervalSince(initialTime)
            
            //Record location every 15mins (900Seconds)
            if elapsed > 3 {
                
                //Check if any of the properties have a null value
                if let driverId = driverId, let companyCode = companyCode, let loadNumber = loadNumber, let tripId = tripId, let driverName = driverName, let urlData = url  {
                    sendLocation(driverName:driverName, dvrId: driverId, loadNum: loadNumber, tripId: tripId, lat: location.coordinate.latitude, lng: location.coordinate.longitude, speed: Double(location.speed * 3.6),url: urlData, token: token ?? "No Token", companyCode: companyCode)
                }else {
                    print("Can not post location, a property is null.")
                }
                self.initialTime = time
            }
        }
    }
    
    //Send location data to url endpoint
    func sendLocation(driverName: String, dvrId: String, loadNum: String, tripId: String, lat: Double, lng: Double, speed: Double, url: String, token: String, companyCode: String)  {
        
        let locationServiceURL = URL(string: url);
        
        let parameters = ["driverName":driverName, "Driver1Id":dvrId, "TripNumber":loadNum, "tripId": tripId, "Latitude":lat,"Longitude":lng,"speed":speed, "CompanyCode": companyCode] as [String : Any]
        var request = URLRequest(url: locationServiceURL!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(companyCode, forHTTPHeaderField: "CompanyCode")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            print("\nHTTP_BODY:\(parameters)")
            print("\n\nRESPONSE: \(String(describing: response))\n\n")
            print("\nERROR: \(error.debugDescription)\n\n")
        }.resume()
    }
}
