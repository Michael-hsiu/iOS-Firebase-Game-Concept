//
//  DungeonViewController.swift
//  Pokefinder App
//
//  Created by Michael Hsiu on 12/6/16.
//  Copyright © 2016 Michael Hsiu. All rights reserved.
//

import UIKit

class DungeonViewController: UIViewController {
    
    var healthPoints: UInt32 = 100
    var manaPoints: UInt32 = 100
    
    @IBOutlet var timeLeftLabel: UILabel!
    @IBOutlet var hpAmntLabel: UILabel!
    @IBOutlet var mpAmntLabel: UILabel!
    @IBOutlet var dungeonTime: UILabel!
    
    var dungeonTimer = Timer()
    
    @IBAction func leaveButton(_ sender: Any) {
        dungeonTimer.invalidate()
    }
    
    /* [PLAYER SIDE] */
    // Periodic HP/MP recovery
    
    
    // Poison effect
    
    // Boss HP test methods
    @IBOutlet var bossHPLabel: UILabel!
    
    @IBAction func killBoss(_ sender: Any) {
        bossHPLabel.text = String(0)
    }
    
    
    
    // Player HP/MP test methods
    @IBAction func increaseHP(_ sender: Any) {
        var amnt = arc4random_uniform(10)
        healthPoints += amnt
        hpAmntLabel.text = String(healthPoints)
    }
    
    @IBAction func lowerHP(_ sender: Any) {
        var amnt = arc4random_uniform(10)
        healthPoints -= amnt
        hpAmntLabel.text = String(healthPoints)
    }
    
    @IBAction func increaseMP(_ sender: Any) {
        var amnt = arc4random_uniform(10)
        manaPoints += amnt
        mpAmntLabel.text = String(manaPoints)
    }
    
    @IBAction func lowerMP(_ sender: Any) {
        var amnt = arc4random_uniform(10)
        manaPoints -= amnt
        mpAmntLabel.text = String(manaPoints)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Establish Dungeon Timer!
        if !dungeonTimer.isValid {
            dungeonTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DungeonViewController.processTimer), userInfo: nil, repeats: true)
        }
    }

    
    func processTimer() {
        if let checkText = dungeonTime.text { // Check that label has text
            let timerText = Int(checkText) // Check that label text can be wrapped to Int
            if let timerTextHelper = timerText {    // Check that an Int was assigned
                if timerTextHelper > 0 {
                    dungeonTime.text = String(timerTextHelper - 1)    // Subtract 1 from the time
                } else if timerTextHelper == 0 {
                    // Instantiate the Map, leaving the dungeon
                    if dungeonTimer.isValid {
                        dungeonTimer.invalidate()   // Kill the timer
                    }
                    
                    // Did player win or lose dungeon?
                    if bossHPLabel.text == "0" {
                        let victoryVC = UIStoryboard(name: "Dungeons", bundle: nil).instantiateViewController(withIdentifier: "VictoryExit") as! VictoryDungeonExitViewController
                        self.present(victoryVC, animated: true, completion: nil)

                    } else {
                        let defeatVC = UIStoryboard(name: "Dungeons", bundle: nil).instantiateViewController(withIdentifier: "DefeatExit") as! DefeatDungeonExitViewController
                        self.present(defeatVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
