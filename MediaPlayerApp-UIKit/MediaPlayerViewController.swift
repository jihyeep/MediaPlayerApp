//
//  ViewController.swift
//  MediaPlayerApp-UIKit
//
//  Created by 박지혜 on 7/5/24.
//

import UIKit
import AVFoundation

extension UIButton {
    static func createPlayControlButton(sysytemImage: String, pointSize: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: sysytemImage)?
            .applyingSymbolConfiguration(.init(pointSize: pointSize))
        config.buttonSize = .large
        button.configuration = config
        return button
    }
}

class MediaPlayerViewController: UIViewController {
    let item: MediaItem
    
    lazy var playerItem = AVPlayerItem(url: item.url)
    lazy var player = AVPlayer(playerItem: playerItem)
    private var playerLayer: AVPlayerLayer?
    
    var goPrev: (() -> Void)?
    var goNext: (() -> Void)?
    
    var isPlaying: Bool = false {
        didSet {
            playButton.isHidden = isPlaying
            pauseButton.isHidden = !isPlaying
        }
    }
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let playButton = UIButton.createPlayControlButton(sysytemImage: "play.fill", pointSize: 48)
    let pauseButton = UIButton.createPlayControlButton(sysytemImage: "pause.fill", pointSize: 48)
    let prevButton = UIButton.createPlayControlButton(sysytemImage: "backward.fill", pointSize: 32)
    let nextButton = UIButton.createPlayControlButton(sysytemImage: "forward.fill", pointSize: 32)
    
    lazy var playControlStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [prevButton, playButton, pauseButton, nextButton])
        view.distribution = .equalCentering
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressBar: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let volumeSlider: UISlider = {
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(item: MediaItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = item.title
        
        setupUI()
        preparePlay()
    }
    
    private func setupUI() {
        self.view.addSubview(imageView)
        imageView.image = UIImage(systemName: item.isVideo ? "video.square.fill" : "music.note")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray5
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 150),
            imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        self.view.addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            progressBar.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            progressBar.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        self.view.addSubview(playControlStack)
        
        NSLayoutConstraint.activate([
            playControlStack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            playControlStack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            playControlStack.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 30),
        ])
        
        playButton.addAction(UIAction { [weak self] _ in
            self?.play()
            self?.isPlaying = true
        }, for: .touchUpInside)
        
        pauseButton.addAction(UIAction { [weak self] _ in
            self?.pause()
            self?.isPlaying = false
        }, for: .touchUpInside)
        
        prevButton.addAction(UIAction { [weak self] _ in
            self?.goPrev?()
        }, for: .touchUpInside)
        
        nextButton.addAction(UIAction { [weak self] _ in
            self?.goNext?()
        }, for: .touchUpInside)
        
        prevButton.isEnabled = goPrev != nil /// goPrev이 nil이 아니면 prevButton 활성화
        nextButton.isEnabled = goNext != nil
        
        // 드래그(pan gesture)
        progressBar.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(seekMusic)))
    }
    
    // 주기적으로 현재 재생 시간과 총 재생 시간을 확인하여 progress bar를 업데이트
    func preparePlay() {
        isPlaying = false
        
        // 총 재생 시간
        print(playerItem.duration)
        
        // 0.1초마다 주기적으로 timeObserver 호출
        let interval = CMTimeMakeWithSeconds(0.1, preferredTimescale: Int32(NSEC_PER_SEC))
        // TimeObserver 추가
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] elapsedSeconds in
            if let currentItem = self?.player.currentItem {
                // 총 재생 시간
                let duration = CMTimeGetSeconds(currentItem.duration)
                // 현재 재생 시간
                let currentTime = CMTimeGetSeconds(currentItem.currentTime())
                
                // UI 업데이트이므로 메인 큐에서 실행
                DispatchQueue.main.async {
                    if duration.isNaN || duration == 0 {
                        self?.progressBar.progress = 0
                    } else {
                        self?.progressBar.progress = Float(currentTime / duration)
                    }
                }
                
                print("Duration: \(duration) s")
                print("Current time: \(currentTime) s")
            }
        })
    }
    
    func play() {
        print("play")
        
        if item.isVideo {
            imageView.isHidden = true
            
            playerLayer = AVPlayerLayer(player: player)
            
            // playerLayer 프레임 크기를 비율에 맞춰 설정
            let videoAspectRatio: CGFloat = 16.0 / 9.0 /// 16:9 비율
            let playerWidth = view.bounds.width
            let playerHeight = playerWidth / videoAspectRatio
            let playerYPosition = imageView.frame.origin.y
            
            playerLayer?.frame = CGRect(x: 0, y: playerYPosition, width: playerWidth, height: playerHeight)
            playerLayer?.videoGravity = .resizeAspect
            
            if let playerLayer = playerLayer {
                self.view.layer.addSublayer(playerLayer)
                player.play()
            }
        } else {
            player.play()
        }
    }
    
    func pause() {
        print("pause")
        player.pause()
    }
    
    @objc func seekMusic(_ sender: UIProgressView) {
        print(sender)
    }
}

#Preview {
    return UINavigationController(rootViewController: MediaPlayerViewController(item: MediaItem.samples[1]))
}

