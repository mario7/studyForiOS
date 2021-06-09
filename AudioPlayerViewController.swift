//
//  ViewController.swift
//  BorderLineSample
//
//  Created by snowman on 2021/05/25.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var sampleView: CustomView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var slider: UISlider!
    
    private var audioPlayer: AVAudioPlayer?
    private var documentController: UIDocumentInteractionController?
    
    private let skipInterval: Double = 10
    private var timeObserverToken: Any?
    private var itemDuration: Double = 0
    private var avPlayer = AVPlayer()
    
    private var mp3FilePathString: URL? {
        Bundle.main.url(forResource: "sample", withExtension: "mp3")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupAudioSession()
        setupPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        showDocumentAudio()
        //prepareToPlayer()
        //avPlayer.play()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let seconds = Double(sender.value) * itemDuration
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: seconds, preferredTimescale: timeScale)
        
        changePosition(time: time)
    }
    
}

extension AudioPlayerViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension AudioPlayerViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        return
    }
}

// private
extension AudioPlayerViewController {
    
    private func showDocumentAudio() {
        
        guard let audioUrl = mp3FilePathString else { return }
        
        self.documentController = UIDocumentInteractionController(url: audioUrl)
        
        documentController?.delegate = self
        documentController?.presentPreview(animated: true)
        
        //        documentController?.uti = "public.mp3,public.audio" //"net.whatsapp.audio"
        //        if documentController?.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true) == false {
        //            print("対応するアプリがありません")
        //        }
        
    }
    
    private func prepareToPlayer() {
        
        guard let audioUrl = mp3FilePathString else { return }
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
            return
        }
        
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
    }
    
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        do {
            try audioSession.setActive(true)
            print("audio session set active !!")
        } catch {
            print("audio exception!!")
        }
    }
    
    private func setupPlayer() {
        
        playerView.player = avPlayer
        addPeriodicTimeObserver()
        replacePlayerItem()
        
    }
    
    private func replacePlayerItem() {
        guard let audioUrl = mp3FilePathString else { return }
        
        let asset = AVAsset(url: audioUrl)
        itemDuration = CMTimeGetSeconds(asset.duration)
        
        let item = AVPlayerItem(url: audioUrl)
        avPlayer.replaceCurrentItem(with: item)
    }
    
    private func updateSlider() {
        let time = avPlayer.currentItem?.currentTime() ?? CMTime.zero
        if itemDuration != 0 {
            slider.value = Float(CMTimeGetSeconds(time) / itemDuration)
        }
    }
    
    private func changePosition(time: CMTime) {
        let rate = avPlayer.rate
        // playerをとめる
        avPlayer.rate = 0
        // 指定した時間へ移動
        avPlayer.seek(to: time) { [weak self] _ in
            // playerをrateに戻す
            self?.avPlayer.rate = rate
        }
    }
    
}

//PeriodicTimeObserver
extension AudioPlayerViewController {
    
    private func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        self.timeObserverToken = avPlayer.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            DispatchQueue.main.async {
                print("update timer:\(CMTimeGetSeconds(time))")
                // sliderを更新
                self?.updateSlider()
            }
        }
    }
    
    private func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            avPlayer.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
}

class CustomView: UIView {
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x:0.0, y: rect.maxY / 2.0))
        
        aPath.addLine(to: CGPoint(x: rect.maxX , y: rect.maxY / 2.0))
        
        aPath.move(to: CGPoint(x: rect.maxX / 2.0, y: 0.0))
        
        aPath.addLine(to: CGPoint(x: rect.maxX / 2.0 , y: rect.maxY))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        
        //If you want to stroke it with a red color
        UIColor.green.set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
    }
}


extension UIView {
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: UIColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY,
                                          width: thickness, height: frame.height)
        case .Right: border.frame = CGRect(x: frame.maxX - thickness, y: frame.minY,
                                           width: thickness, height: frame.height)
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY,
                                         width: frame.width, height: thickness)
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY - thickness,
                                            width: frame.width, height: thickness)
        }
        
        layer.addSublayer(border)
    }
}

class PlayerView: UIView {
    
    // The player assigned to this view, if any.
    var player: AVPlayer? {
        get { return playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    // The layer used by the player.
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Set the class of the layer for this view.
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
