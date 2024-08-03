
import UIKit
import AVFoundation

class CollectionViewCell: UICollectionViewCell {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var thumbnailImageView: UIImageView!
    var videoURL: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupThumbnailImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupThumbnailImageView() {
        thumbnailImageView = UIImageView(frame: bounds)
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        contentView.addSubview(thumbnailImageView)
    }
    
    func configure(with videoURL: String) {
        self.videoURL = videoURL
        generateThumbnail(from: videoURL)
    }
    
    private func generateThumbnail(from url: String) {
        guard let videoURL = URL(string: url) else {
            self.thumbnailImageView.image = UIImage(named: "placeholder")
            return
        }
        
        DispatchQueue.global().async {
            let asset = AVAsset(url: videoURL)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            let time = CMTime(seconds: 1, preferredTimescale: 60)
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let uiImage = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    
                    self.thumbnailImageView.image = uiImage
                }
            } catch {
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = UIImage(named: "placeholder")
                }
                print("Error generating thumbnail: \(error)")
            }
        }
    }
    
    func playVideo(completion: @escaping () -> Void) {
        guard let videoURL = videoURL, let url = URL(string: videoURL) else { return }
        
        player = AVPlayer(url: url)
        player?.rate = 2.0
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = playerLayer {
            contentView.layer.addSublayer(playerLayer)
        }
        
        player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        player?.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.player?.pause()
            self?.playerLayer?.removeFromSuperlayer()
            self?.playerLayer = nil
            completion()
        }
    }
}
