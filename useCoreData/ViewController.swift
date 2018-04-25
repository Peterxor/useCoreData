//
//  ViewController.swift
//  useCoreData
//
//  Created by Peter on 2018/4/24.
//  Copyright © 2018年 Peter. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewController: UIViewController{
    var timer: Timer!
    var button: UIButton?
    var label: UILabel?
    var persistentContainer: NSPersistentContainer?
    var managedObject: TimeMO?
    var another: TimeMO?
    init(container: NSPersistentContainer?) {
        super.init(nibName: nil, bundle: nil)
        persistentContainer = container
        managedObject = NSEntityDescription.insertNewObject(forEntityName: "Time", into: (persistentContainer?.viewContext)!) as? TimeMO
        another = NSEntityDescription.insertNewObject(forEntityName: "Time", into: (persistentContainer?.viewContext)!) as? TimeMO
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button = UIButton.init(frame: CGRect.init(x: 100, y: 600, width: 100, height: 100))
        button?.setTitle("Start", for: .normal)
        button?.setTitleColor(.red, for: .normal)
        button?.addTarget(self, action: #selector(self.play), for: .touchDown)
        button?.isEnabled = true
        self.view.addSubview(button!)
        
        label = UILabel.init(frame: CGRect.init(x: 100, y: 200, width: 100, height: 100))
        label?.text = String.init(format: "%.1f, %.1f", (managedObject?.timeValue)!, (another?.timeValue)!)
        self.view.addSubview(label!)
    }
    
    @objc func play(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timeRun), userInfo: nil, repeats: true)
        button?.isEnabled = false
    }
    
    @objc func timeRun(){
        managedObject?.timeValue = (managedObject?.timeValue)! + 0.1
        label?.text = String.init(format: "%.1f, %.1f", (managedObject?.timeValue)!, (another?.timeValue)!)
    }
    
    
}
