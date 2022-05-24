//
//  ExploreViewController.swift
//  BirdsOfIstanbul
//
//  Created by Can Koz on 13.04.2022.
//

import UIKit
import MapKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class ObservationsViewController: BaseViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var records: [RecordPin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await downloadData()
        }
    }
    
    func configureMapview() {
        var latArray: [Double] = []
        var longArray: [Double] = []
        for record in records {
            let pin = RecordAnnotation()
            pin.data = RecordPin(lat: record.lat, long: record.long, downloadURL: record.downloadURL, stamp: record.stamp)
            pin.coordinate = CLLocationCoordinate2D(latitude: record.lat, longitude: record.long)
            if record.lat != 0 || record.long != 0 {
                latArray.append(record.lat)
                longArray.append(record.long)
            }
            pin.title = record.stamp
            mapView.addAnnotation(pin)
        }
        let initialLocation = CLLocationCoordinate2D(latitude: getAverage(nums: latArray), longitude: getAverage(nums: longArray))
        if !latArray.isEmpty && !longArray.isEmpty {
            mapView.setCenter(initialLocation, animated: true)
        }
    }
    
    func getAverage(nums: [Double]) -> Double {
        var temp = 0.0
        for num in nums
        {
            temp+=num
        }
        let div = Double(nums.count)
        return temp/div
    }

    func downloadData() async {
        showLoading()
        let auth = Auth.auth()
        let db = Firestore.firestore()
        var documents: [QueryDocumentSnapshot] = []
        
        do {
            let snapshot = try await db.collection(auth.currentUser!.uid).getDocuments()
            documents = snapshot.documents
        } catch {
            print("There was an error")
        }
        
        for document in documents {
            guard let downloadURL = document.get("audioURL") as? String,
                  let timestamp = document.get("time") as? String,
                  let location = document.get("location") as? [String: Any],
                  let lat = location["Latitude"] as? Double,
                  let long = location["Longitude"] as? Double else { return }
            let record = RecordPin(lat: lat, long: long, downloadURL: downloadURL, stamp: timestamp)
            records.append(record)
        }
        self.hideLoading()
        configureMapview()
    }
}

extension ObservationsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "identifier")

           if annotationView == nil {
               annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "identifier")
               annotationView?.canShowCallout = true
               let btn = UIButton(type: .contactAdd)
               annotationView?.rightCalloutAccessoryView = btn
           } else {
               annotationView?.annotation = annotation
           }
           return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? RecordAnnotation {
            let data = annotation.data
            tabBarController?.selectedIndex = 0
            let navVC = tabBarController?.viewControllers![0] as! UINavigationController//
            let vc = navVC.topViewController as! RecordingViewController
            vc.addNewRecording(record: data)
        }
    }
}

class RecordAnnotation : MKPointAnnotation {
    var data: RecordPin?
}
