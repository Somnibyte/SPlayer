//
//  SPlayer.swift
//  SPlayer Example
//
//  Created by Guled on 10/14/15.
//  Copyright © 2015 Guled. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class SPlayer: UIView {
    
    // Player Modes
    enum Mode{
        case withoutButton
        case withButton
    }
    
    enum Position{
        case Top
        case Bottom
    }
    
    // Components within SPlayer
    var playerMode:Mode = .withoutButton
    var playersCurrentPosition:Position?
    var sliderBaseView:UIView!
    var slider:UISlider!
    var playButton:UIButton!
    var loadedAudio:NSURL!
    var player:AVAudioPlayer!
    var isPlaying:Bool = false
    var playButtonImageName = "playButton"
    var stopButtonImageName = "stopButton"
    
    
    
    // Given Frame
    var otherFrame:UIView!
    
    // Measurements
    var offsetY:CGFloat = 0.0 // default offset
    
    //# MARK: - Text Methods
    init(frame: CGRect, offsetY:CGFloat, playerMode:Mode) {
        super.init(frame: frame)
        
        // Players default configurations
        self.backgroundColor = UIColor.whiteColor()
        self.frame.size.height = 50
        self.frame.size.width = frame.size.width
        //self.clipsToBounds = true
        
        // Set the y offset
        self.offsetY = offsetY
        
        
        // Set the outside frame 
        self.otherFrame = UIView(frame: frame)
        
        // Set the players mode
        self.playerMode = playerMode
        
        // Move the player to that offset
        self.frame.origin.y = offsetY
        
        // Initialize sliders baseview
        
        // SliderBaseView Defaults
        
        // If the player mode is set to .withoutButton, then we can just make
        // ...the SliderBaseView full width since the user may now be using
        // ... an external button
        
        var sliderBaseViewWidth:CGFloat!
        var sliderBaseViewHeight:CGFloat!
        var sliderBaseViewPosX:CGFloat!
        var sliderBaseViewPosY:CGFloat!
        let sliderWidth:CGFloat!
        let sliderHeight:CGFloat!
        let sliderPosX:CGFloat!
        let sliderPosY:CGFloat!
        
        print(self.playerMode)
        if self.playerMode == .withoutButton {
            sliderBaseViewPosX = self.frame.origin.x
            sliderBaseViewWidth = self.frame.width
            
            
        }else if self.playerMode == .withButton {
            // If the user uses the .withButton mode, then
            // ...we must reduce the width of the SliderBaseView
            // ... to allow for buttons to be next to it and other
            /// ... UI elements. This is adjustable
            sliderBaseViewWidth = self.frame.width
            sliderBaseViewPosX = self.frame.origin.x + 50;
            
            // Debugging
            print("Player is with button.");
            print("Half of the screen is: \(sliderBaseViewPosX)");
        }
        
        
        
        sliderBaseViewHeight = self.frame.height
        sliderBaseViewPosY = 0.0
        
        
        self.sliderBaseView = UIView(frame: CGRect(x: sliderBaseViewPosX, y: sliderBaseViewPosY, width: sliderBaseViewWidth, height: sliderBaseViewHeight))
        self.sliderBaseView.backgroundColor = UIColor.whiteColor()
        
        // Add the SliderBaseView to the actual player
        self.addSubview(sliderBaseView)
        
        
        // Initialize and incorporate separate components to the player
        
        // Initialize the slider
        // Slider Defaults
        sliderWidth = self.sliderBaseView.frame.size.width
        sliderHeight = self.frame.size.height / 2.0
        sliderPosX = 0
        sliderPosY = (self.frame.height / 2.0) - (sliderHeight / 2.0)
        
        slider = UISlider(frame: CGRect(x: sliderPosX, y: sliderPosY, width: sliderWidth, height: sliderHeight))
        
        // Add Slider to SliderBaseView
        self.sliderBaseView.addSubview(slider)
        
        
        // Initialize the button (The button is only initialized when you set the mode to .withButton)
        // Button Defaults
        
        if(self.playerMode == .withButton)
        {
         
            let buttonPosX:CGFloat  = self.frame.origin.x + 10
            let buttonPosY:CGFloat  = self.frame.size.height/4
        
            playButton = UIButton(type: .InfoLight)
            playButton.frame.origin.x = buttonPosX
            playButton.frame.origin.y = buttonPosY
            playButton.setImage(UIImage(named: playButtonImageName), forState: UIControlState.Normal)
            playButton.addTarget(self, action: "play", forControlEvents: UIControlEvents.TouchUpInside)
      
            print("Button x is located in:  \(playButton.frame.origin.x)")
           self.addSubview(playButton)
            
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder is not supported.")
    }
    
    
    func movePlayerTo(position:Position){
        
        if position == .Top {
            self.frame.origin.y = self.otherFrame.frame.origin.y + 20
            
            // Set the current players position
            self.playersCurrentPosition = Position.Top
            
        }else if position == .Bottom {
            self.frame.origin.y = self.otherFrame.frame.origin.y + self.otherFrame.frame.size.height - 50
            
            // Set the current players position
            self.playersCurrentPosition = Position.Bottom
        }
    }
    
    /**
     The loadAudio function takes in an audio file as input and calculates how many times the dials should move until it reaches the end of the scale. The playAudio function also removes the player from it's 'hidden' state.
     
     */
    func loadAudio(fileName:String, audioType:String){
        // Search for the specfic source of the audio

        loadedAudio = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileName, ofType: audioType)!)
        
    }
    

    func play(){
        
        // Toggle controls
        if !self.isPlaying {
            self.isPlaying = true
            self.playButton.setImage(UIImage(named: stopButtonImageName), forState: UIControlState.Normal)
            // Attempt to play audio
            do{
                self.player = try AVAudioPlayer(contentsOfURL: loadedAudio)
                self.player.prepareToPlay()
                self.player.play()
            }catch {
                print("Error getting the audio file")
            }

        } else {
             self.isPlaying = false
             self.playButton.setImage(UIImage(named: playButtonImageName), forState: UIControlState.Normal)
             self.player.stop()
        }
    
    
    }
    
    /**
     Hide the player.
     
     */
    func hidePlayer(){
        self.hidden = true;
    }

    /**
     Show the player.
     
     */
    func showPlayer(){
        self.hidden = false;
    }
    
    
    
    
    /**
    The addShadow function simply adds a shadow to the sliderBaseView (which in this case is not clipped to the bounds of the player view to allow the shadow to show. This is adjustable.
    
    */
    func addShadow(color:CGColorRef = UIColor.blackColor().CGColor, opacity:Float = 0.4, offset:CGSize = CGSize(width: 0, height: 10), radius:CGFloat = 5){
        
            self.sliderBaseView.layer.shadowColor = color
            self.sliderBaseView.layer.shadowOpacity = opacity
            self.sliderBaseView.layer.shadowRadius = radius
            self.sliderBaseView.layer.shadowOffset = offset
    }
    
    
}

