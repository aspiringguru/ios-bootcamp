//
//  ViewController.swift
//  FancyClock
//
//  Created by Javan Wood on 21/4/17.
//  Copyright © 2017 iOS Bootcamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var timeFormatter = DateFormatter()
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("World")
        
        dateFormatter.locale = Locale(identifier: "")
        
        timeFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .full
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            let currentTime = Date()
            self?.timeLabel.text = self?.timeFormatter.string(from: currentTime)
            self?.dateLabel.text = self?.dateFormatter.string(from: currentTime)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
