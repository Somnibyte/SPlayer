//
//  ViewController.swift
//  SPlayer Example
//
//  Created by Guled on 10/14/15.
//  Copyright © 2015 Guled. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the SPlayer
        let player = SPlayer(frame: self.view.frame, offsetY: 0, playerMode: .withButton)
        
        // Incorporate some configurations that you like
        player.movePlayerTo(.Bottom)
        
        
        // Add the player to your view
        self.view.addSubview(player)

        
        player.loadAudio("storm", audioType: "wav")
    }
    
    override func viewWillLayoutSubviews() {
 
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

