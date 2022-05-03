//
//  NetworkPickerViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 26.04.2022.
//

import UIKit

class NetworkPickerViewController: LogoAnimatableViewController, INetworkPickerView {
    
    var presenter: INetworkPickerPresenter?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        layout.scrollDirection = .vertical
        layout.collectionView?.backgroundColor = ThemePicker.shared.currentTheme?.backgroundColor
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(
            UINib(nibName: "PhotoCollectionViewCell", bundle: Bundle.main),
            forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier
        )
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        presenter?.onViewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
    }
    
    func success() {
        collectionView.reloadData()
    }
    
    func failure() {
        print("error")
        showErrorAlert()
    }
    
    private func showErrorAlert() {
        let alertVC = UIAlertController(title: "Error",
                                        message: "Something went wrong. Try again later",
                                        preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
}

// MARK: - collectionView datasource

extension NetworkPickerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.photoURLs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        guard let item = presenter?.photoURLs[indexPath.row] else { return UICollectionViewCell() }
        cell.configure(with: item, isSelected: false)
        
        return cell
    }
    
}

// MARK: - collectionViewDelegateFlowLayout

extension NetworkPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = CGFloat(1.0)
        let cellWidth = collectionView.frame.size.width / 3 - 4 * spacing
        let cellHeight = cellWidth
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

// MARK: - collectionView delegate

extension NetworkPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urlString = presenter?.photoURLs[indexPath.item].webformatURL else { return }
        presenter?.photoHasChosen(urlString)
    }
}
