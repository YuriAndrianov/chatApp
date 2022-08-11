//
//  PhotoCollectionViewCell.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 26.04.2022.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "cell"
    
    @IBOutlet private weak var imageView: PhotoImageView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.setImage(nil)
    }
    
    func configure(with item: PhotoItem, isSelected: Bool) {
        guard let urlString = item.webformatURL else { return }
        imageView?.setImage(from: urlString)
    }
}
