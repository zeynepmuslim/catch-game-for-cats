//
//  ViewController.swift
//  lazer
//
//  Created by Zeynep Müslim on 25.03.2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
       
    @IBOutlet weak var lazer: UIImageView!
    @IBOutlet weak var backGame: UIImageView!
    @IBOutlet weak var hand: UIImageView!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backStart: UIImageView!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var backAgain: UIImageView!
    @IBOutlet weak var skorLabel: UILabel!
    @IBOutlet weak var activeScoreLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var holdLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    
    var heightscore = 0
    var score = 0
    
    var count = 119
    var timeLeft : Int!
    
    let defaults = UserDefaults.standard
    
    var lazerSoundEffect: AVAudioPlayer?
    var meowSoundEffect: AVAudioPlayer?
    
    var lazerw = CGFloat(50)
    var lazerh = CGFloat(50)
    
    var backGameW = CGFloat(100)
    var backGameH = CGFloat(100)
    
    var handW = CGFloat(50)
    var handH = CGFloat(50)
    
    var timer : Timer!
    var timerBack : Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "heightscore") == nil {
            UserDefaults.standard.set(0, forKey: "heightscore")
        }
        
        timeLeft = count
        
        activeScoreLabel.textColor = UIColor.black
        countdownLabel.textColor = UIColor.black
        
        backStart.layer.zPosition = 10
        playButton.isEnabled = true
        playButton.alpha = 1.0
        playButton.layer.zPosition = 15
        playButton.layer.cornerRadius = 15
        creatorLabel.layer.zPosition = 15
        
        againButton.layer.zPosition = 2
        let againButtonSize = view.bounds.height / 4
        againButton.frame = CGRect(x: view.bounds.width / 2 - againButtonSize / 2, y: view.bounds.height - 600 , width: againButtonSize, height: againButtonSize)
        highscoreLabel.frame = CGRect(x: 0, y: +120 , width: view.bounds.width, height: view.bounds.width / 10)
        skorLabel.frame = CGRect(x: 0, y: +210, width: view.bounds.width, height: view.bounds.width / 10)
        
        xButton.alpha = 0.0
        xButton.alpha = 0.0
        
        backGameW = view.bounds.width
        backGameH = view.bounds.height
        backGame.layer.zPosition = -10
        
        handW = view.bounds.width / 10
        handH = handW
        
        backGame.frame = CGRect(x: 0, y: 0, width: backGameW, height: backGameH)
        backStart.frame = CGRect(x: 0, y: 0, width: backGameW, height: backGameH)
        backAgain.frame = CGRect(x: 0, y: 0, width: backGameW, height: backGameH)
        backAgain.alpha = 0.0
        againButton.alpha = 0.0
        againButton.isEnabled = false
        skorLabel.alpha = 0.0
        highscoreLabel.alpha = 0.0
        
        lazerw = view.bounds.width / 10
        lazerh = lazerw
        
        
        
        newLazer()
        
        let buttonSize = view.bounds.width / 10
        xButton.frame = CGRect(x: view.bounds.width - buttonSize * 1.5, y: view.bounds.height - buttonSize * 1.5, width: buttonSize, height: buttonSize)
        
        let playButtonW = view.bounds.height / 3
        let playButtonH = playButtonW / 2
        
        creatorLabel.frame = CGRect(x: view.bounds.width / 2 - 400 / 2, y: view.bounds.height / 2 + playButtonH, width: 400, height: 200)
        creatorLabel.textColor = UIColor.darkGray
        playButton.frame = CGRect(x: view.bounds.width / 2 - playButtonW / 2, y: view.bounds.height / 2 - playButtonH / 2, width: playButtonW, height: playButtonH)
        
        let tapGestureRecognizerSkor = UITapGestureRecognizer(target: self, action: #selector(addSkor))
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(activeButton))

        lazer.isUserInteractionEnabled = true
        lazer.addGestureRecognizer(tapGestureRecognizerSkor)
        
        activeScoreLabel.frame = CGRect(x: 0 + handW * 2, y: 0 + handH / 2, width: view.bounds.width - handW * 2, height: 30)
        countdownLabel.frame = CGRect(x: view.bounds.height - 150, y: 0 + handH / 2, width: 300, height: 35)
        
        holdLabel.frame = CGRect(x: 0 + handW / 2, y: 0 + handH * 1.5, width: handH, height: handW / 2)
        holdLabel.textColor = UIColor.black
        
        hand.frame = CGRect(x: 0 + handW / 2, y: 0 + handH / 2, width: handH, height: handW)
        hand.isUserInteractionEnabled = true
        hand.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func activeButton() {
        xButton.alpha = 1.0
        xButton.isEnabled = true
    }
    
    func stopTimer() {
        timer.invalidate()
        timerBack.invalidate()
        timeLeft = count
        
        UIView.animate(withDuration: 0.5) {
            self.activeScoreLabel.alpha = 0.0
            self.activeScoreLabel.text = "Score: 0"
            self.holdLabel.alpha = 0.0
            self.backAgain.alpha = 1.0
            self.againButton.alpha = 1.0
            self.againButton.isEnabled = true
            self.skorLabel.alpha = 1.0
            self.highscoreLabel.alpha = 1.0
        }
        
        let storedHeightscore = UserDefaults.standard.object(forKey: "heightscore")
        
        print(storedHeightscore!)
        
        if let newScore = storedHeightscore as? Int {
            heightscore = newScore
            highscoreLabel.text = "Highscore: \(heightscore)"
        }

        if score > heightscore {
            heightscore = score
            
            highscoreLabel.text = "Highscore: \(heightscore)"
            UserDefaults.standard.set(heightscore, forKey: "heightscore")
        }
        
        highscoreLabel.text = "Highscore: \(heightscore)"
        skorLabel.text = "Score: \(score)"
        
        skorLabel.layer.zPosition = 15
        highscoreLabel.layer.zPosition = 15
        
        print("tıklandım")
    }
    
    func startGame() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        countdown()
    }
    
    
    

    func countdown() {
        var timeLeft = count
        timerBack = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeLeft != 0 {
                print("\(timeLeft)")
                //buraya bak
                self.countdownLabel.text = String(timeLeft)
                
                timeLeft -= 1
            } else {
                self.timerBack.invalidate()
                self.xButtonClicked((Any).self)
                timeLeft = self.count
            }
        }
    }
     
    @IBAction func playButtonClicked(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.backStart.layer.zPosition = -15
            self.playButton.isEnabled = false
            self.playButton.alpha = 0.0
            self.holdLabel.alpha = 1.0
        }
        
        playButton.layer.zPosition = -20
        creatorLabel.layer.zPosition = -20
        score = 0
        activeScoreLabel.text = "Score: \(score)"
        startGame()
        meowSound()
    }
    
    @IBAction func xButtonClicked(_ sender: Any) {
        stopTimer()
    }
    
    @IBAction func againButtonClicked(_ sender: Any) {
        timeLeft = count + 1
        countdownLabel.text = String(timeLeft)
        
        UIView.animate(withDuration: 0.5) {
            self.playButton.alpha = 0.0
            self.backAgain.alpha = 0.0
            self.againButton.alpha = 0.0
            self.skorLabel.alpha = 0.0
            self.highscoreLabel.alpha = 0.0
            self.xButton.alpha = 0.0
            self.activeScoreLabel.alpha = 1.0
            self.holdLabel.alpha = 1.0
        }
        
        backStart.layer.zPosition = -15
        playButton.isEnabled = false
        playButton.layer.zPosition = -20
        creatorLabel.layer.zPosition = -20
        againButton.isEnabled = false
        xButton.isEnabled = false
        score = 0
        startGame()
    }
    
    @objc func addSkor() {
        newLazer()
        score+=1
        activeScoreLabel.text = "Score: \(score)"
        lazerSound()
        print(score)
    }
    
    func newLazer() {
        
        let maxX = view.frame.maxY - lazerw
        let maxY = view.frame.maxX - lazerh
        let randomX = arc4random_uniform(UInt32(maxX)) + 0
        let randomY = arc4random_uniform(UInt32(maxY)) + 0
        lazer.frame = CGRect(x: CGFloat(randomX), y: CGFloat(randomY), width: lazerw, height: lazerh)
    }
    
    @objc func fireTimer() {
        movement()
    }
    
    func movement() {
        // x and y swifth for landspace
        let maxX = view.frame.maxX - lazerw
        let maxY = view.frame.maxY - lazerh
        let randomX = arc4random_uniform(UInt32(maxX)) + 0
        let randomY = arc4random_uniform(UInt32(maxY)) + 0
        
        UIView.animate(withDuration: 0.3) {
            self.lazer.frame = CGRect(x: CGFloat(randomX), y: CGFloat(randomY), width: self.lazerw, height: self.lazerh)
        }
        
    }
    
    func lazerSound() {
        let pathToSound = Bundle.main.path(forResource: "lasersound", ofType: "mp3")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("errorlaser")
        }
    
    }
    
    func meowSound() {
        let pathToSound = Bundle.main.path(forResource: "opensound", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("erroropen")
        }
    
    }

}
