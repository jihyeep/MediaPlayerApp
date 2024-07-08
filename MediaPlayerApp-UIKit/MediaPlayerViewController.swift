//
//  ViewController.swift
//  MediaPlayerApp-UIKit
//
//  Created by 박지혜 on 7/5/24.
//

import UIKit

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
        view.addSubview(imageView)
        imageView.image = UIImage(systemName: item.isVideo ? "video.square.fill" : "music.note")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray5

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])

        view.addSubview(progressBar)

        progressBar.progress = 0.5

        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            progressBar.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            progressBar.heightAnchor.constraint(equalToConstant: 8)
        ])

        view.addSubview(playControlStack)

        NSLayoutConstraint.activate([
            playControlStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            playControlStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
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
    }

    func preparePlay() {
        isPlaying = false
    }

    func play() {
        print("play")
    }

    func pause() {
        print("pause")
    }
}

#Preview {
    return UINavigationController(rootViewController: MediaPlayerViewController(item: MediaItem.samples[1]))
}

