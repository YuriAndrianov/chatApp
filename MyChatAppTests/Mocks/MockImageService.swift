//
//  MockImageService.swift
//  MyChatAppTests
//
//  Created by Юрий Андрианов on 16.05.2022.
//

import UIKit
@testable import MyChatApp

final class MockImageService: IImageService {

    var invokedSaveImage = false
    var invokedSaveImageCount = 0
    var invokedSaveImageParameters: (imageName: String, image: UIImage)?
    var invokedSaveImageParametersList = [(imageName: String, image: UIImage)]()

    func saveImage(imageName: String, image: UIImage) {
        invokedSaveImage = true
        invokedSaveImageCount += 1
        invokedSaveImageParameters = (imageName, image)
        invokedSaveImageParametersList.append((imageName, image))
    }

    var invokedLoadImageFromDiskWith = false
    var invokedLoadImageFromDiskWithCount = 0
    var invokedLoadImageFromDiskWithParameters: (fileName: String, Void)?
    var invokedLoadImageFromDiskWithParametersList = [(fileName: String, Void)]()
    var stubbedLoadImageFromDiskWithCompletionResult: (UIImage?, Void)?

    func loadImageFromDiskWith(fileName: String, completion: @escaping ((UIImage?) -> Void)) {
        invokedLoadImageFromDiskWith = true
        invokedLoadImageFromDiskWithCount += 1
        invokedLoadImageFromDiskWithParameters = (fileName, ())
        invokedLoadImageFromDiskWithParametersList.append((fileName, ()))
        if let result = stubbedLoadImageFromDiskWithCompletionResult {
            completion(result.0)
        }
    }

    var invokedDeleteImage = false
    var invokedDeleteImageCount = 0
    var invokedDeleteImageParameters: (imageName: String, Void)?
    var invokedDeleteImageParametersList = [(imageName: String, Void)]()

    func deleteImage(imageName: String) {
        invokedDeleteImage = true
        invokedDeleteImageCount += 1
        invokedDeleteImageParameters = (imageName, ())
        invokedDeleteImageParametersList.append((imageName, ()))
    }
}
