//
//  DetailViewController.swift
//  SiteStrategy
//
//  Created by Irl D Jones on 9/30/16.
//  Copyright © 2016 inSkyLE. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITextViewDelegate {
    

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var photosTV: UITextView!
    @IBOutlet weak var nasaIV: UIImageView!

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.airportCityAbbreviation
                let apiController = APIController()
                let today = NSDate()
                let nsurl = apiController.createURLWithString(date: today)
                print(nsurl)
                var photoStrings = [String]()
                DispatchQueue.main.async (execute: {
                
                photoStrings = apiController.getAPOD(date: today) as! [String]
                /*
                self.photosTV.text = photoStrings.joined(separator: ",")
                print(self.photosTV.text)
                self.photosTV.setNeedsDisplay()*/
                    print("hello")
                    
                    print("here are the photostrings \(photoStrings)")
                    self.photosTV.text = photoStrings.joined(separator: ",")
                })
                
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        print(textView.text);
        textView.setNeedsDisplay()//the textView parameter is the textView where text was changed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photosTV!.delegate = self
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Airport? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

