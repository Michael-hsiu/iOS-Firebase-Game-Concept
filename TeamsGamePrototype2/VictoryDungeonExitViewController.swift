//
//  VictoryDungeonExitViewController.swift
//  Pokefinder App
//
//  Created by Michael Hsiu on 12/10/16.
//  Copyright © 2016 Michael Hsiu. All rights reserved.
//

import UIKit

class VictoryDungeonExitViewController: UIViewController {

    
    @IBAction func leaveDungeon(_ sender: Any) {
        let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Menu") as! MenuViewController
        self.present(menuVC, animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
