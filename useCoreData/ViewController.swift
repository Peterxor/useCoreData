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
    var playBtn: UIButton?
    var stopBtn: UIButton?
    var deleteDataBtn: UIButton?
    var showDataBtn: UIButton?
    var label: UILabel?
    var time: TimeMO?
    var another: TimeMO?
    var context: NSManagedObjectContext?
    var dataNum: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //直接調用persistentContainer
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        time = TimeMO(context: context!)
        playBtn = buttonSet(color: .red, title: "Play", xPos: UIScreen.main.bounds.width/2 - 150, yPos: 300, action: #selector(self.play))
        stopBtn = buttonSet(color: .red, title: "Stop", xPos: UIScreen.main.bounds.width/2 - 150, yPos: 400, action: #selector(self.stop))
        deleteDataBtn = buttonSet(color: .red, title: "Delete Data in Context", xPos: UIScreen.main.bounds.width/2 - 150, yPos: 500, action: #selector(self.deleteData))
        showDataBtn = buttonSet(color: .red, title: "Show Data Number", xPos: UIScreen.main.bounds.width/2 - 150, yPos: 600, action: #selector(self.showData))
        playBtn?.isEnabled = true
        showDataBtn?.isEnabled = true
        
        label = UILabel.init(frame: CGRect.init(x: UIScreen.main.bounds.width/2 - 150, y: 200, width: 300, height: 100))
        label?.text = String.init(format: "%.1f", (time?.timeValue)!)
        label?.textAlignment = .center
        
        self.view.addSubview(label!)
    }
    
    func buttonSet(color: UIColor?, title: String?, xPos: CGFloat, yPos: CGFloat, action: Selector) -> UIButton{
        let button = UIButton.init(frame: CGRect.init(x: xPos, y: yPos, width: 300, height: 100))
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.addTarget(self, action: action, for: .touchDown)
        button.isEnabled = false
        self.view.addSubview(button)
        return button
    }
    
    @objc func play(){
        
        playBtn?.isEnabled = false
        stopBtn?.isEnabled = true
        deleteDataBtn?.isEnabled = false
        showDataBtn?.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timeRun), userInfo: nil, repeats: true)
    }
    
    @objc func stop(){
        timer.invalidate()
        playBtn?.isEnabled = true
        stopBtn?.isEnabled = false
        deleteDataBtn?.isEnabled = true
        showDataBtn?.isEnabled = true
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    @objc func deleteData(){
        
        var timeMos: [TimeMO] = []
        do {
         timeMos  = (try context?.fetch(TimeMO.fetchRequest()))!
        } catch {
            print("fetch error")
        }
        context?.delete(time!)
        if timeMos.count == 1 || timeMos.count == 0{
            label?.text = String("No data in context, so You can't play haha")
            playBtn?.isEnabled = false
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    @objc func showData(){
        var timeMos: [TimeMO] = []
        do {
            timeMos  = (try context?.fetch(TimeMO.fetchRequest()))!
        } catch {
            print("fetch error")
        }
        dataNum = timeMos.count
        label?.text = String.init(format: "%d data in context", timeMos.count)
        for timeMo in timeMos{
            print(timeMo.timeValue)
        }
    }
    
    @objc func timeRun(){
        time?.timeValue = (time?.timeValue)! + 0.1
        label?.text = String.init(format: "%.1f", (time?.timeValue)!)
        
    }
    
    
}
