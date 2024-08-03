


import UIKit

class TableViewCell: UITableViewCell {

    var collectionView: UICollectionView!
    var videoItems: [String] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCollectionView() {
        self.backgroundColor = .lightGray
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.itemSize = CGSize(width: contentView.frame.width / 2 + 20, height: 200)
        
        collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        contentView.addSubview(collectionView)
    }

    func configure(with videoItems: [String]) {
        self.videoItems = videoItems
        collectionView.reloadData()
    }

    func playVideosSequentially() {
        if let visibleCells = collectionView.visibleCells as? [CollectionViewCell] {
            playNextVideo(in: visibleCells, index: 0)
        }
    }

    private func playNextVideo(in cells: [CollectionViewCell], index: Int) {
        guard index < cells.count else { return }

        let cell = cells[index]
        cell.playVideo { [weak self] in
            self?.playNextVideo(in: cells, index: index + 1)
        }
    }
}

extension TableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let videoURL = videoItems[indexPath.item]
        cell.configure(with: videoURL)
        return cell
    }
}

