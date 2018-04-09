//
//  ViewController.swift
//  DoTryCatchTest
//
//  Created by Emiko Clark on 3/22/18.
//  Copyright © 2018 Emiko Clark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var lat:Double?
    var long:Double?

    @IBOutlet weak  var addressLabel: UILabel?
    @IBOutlet weak  var latlongLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // fixed address is: "27 e 13th street, ny, ny 10003"
        let address = "27 e 13th street, ny, ny 10003"

        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=27+e+13th+street,+ny,+ny+10003&key=AIzaSyBeyKemAKSWX5YlymLMMuGFVQEhB7Sn8iE"
        
        guard let urlConverted = URL(string: urlString) else {print("url not converted"); return }
        
        URLSession.shared.dataTask(with: urlConverted) { (data, response, error) in
   
            guard let data = data else {print("data nil"); return }
            
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                // parse
                guard let resultsArr = jsonDict["results"] as? Array<Any> else {print("results array failed"); return }
                
                guard let firstElement = resultsArr.first as? [String:Any] else { print("failed"); return }
                guard let geometryDict = firstElement["geometry"] as? [String: Any] else { print("gemometry failed"); return }
                
                guard let locationDict = geometryDict["location"] as? [String:Any] else {print("location failed");  return }
                
                guard let latcoord = locationDict["lat"] as? Double,
                    let longcoord = locationDict["lng"] as? Double
                    else {print("location failed"); return }

                self.lat  = Double(latcoord)
                self.long = Double(longcoord)

                print("Address: \(address) \nLat: \(self.lat!)\nLong: \(self.long!)")
            } catch {
                print("error:::: \(error)")
            }
        }.resume()

    }

}

