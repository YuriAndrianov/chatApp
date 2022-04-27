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
        imageView?.setImage(from: "https://cdn.pixabay.com/user/2017/07/18/13-46-18-393_250x250.jpg")
        super.prepareForReuse()
    }
    
    func configure(with item: PhotoItem, isSelected: Bool) {
        guard let urlString = item.userImageURL else { return }
        imageView?.setImage(from: urlString)
    }
    
}
