//
//  ImageService.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 17.04.2022.
//

import UIKit

protocol IImageService: AnyObject {
    
    func saveImage(imageName: String, image: UIImage)
    
    func loadImageFromDiskWith(fileName: String, completion: @escaping ((UIImage?) -> Void))
    
    func deleteImage(imageName: String)
    
}
