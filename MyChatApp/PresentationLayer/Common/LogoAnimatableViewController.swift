//
//  LogoAnimatableViewController.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 03.05.2022.
//

import UIKit

class LogoAnimatableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(animate)))
    }
    
    private lazy var logoLayer: CAEmitterLayer = {
        let logoLayer = CAEmitterLayer()
        logoLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        logoLayer.emitterShape = CAEmitterLayerEmitterShape.point
        logoLayer.beginTime = CACurrentMediaTime()
        logoLayer.timeOffset = CFTimeInterval(1)
        logoLayer.emitterCells = [logoCell]
        return logoLayer
    }()
    
    private lazy var logoCell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "tcsLogo")?.cgImage
        cell.scale = 0.001
        cell.scaleRange = 0.1
        cell.emissionRange = .pi
        cell.lifetime = 1
        cell.birthRate = 5
        cell.velocity = -10
        cell.velocityRange = -10
        cell.yAcceleration = 10
        cell.xAcceleration = 5
        cell.spin = -0.5
        cell.spinRange = 1.0
        return cell
    }()
    
    @objc func animate(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let position = sender.location(in: view)
            startLogoAnimation(position)
        case .changed:
            stopLogoAnimation()
            let newPosition = sender.location(in: view)
            startLogoAnimation(newPosition)
        default:
            stopLogoAnimation()
        }
    }
    
    private func startLogoAnimation(_ position: CGPoint) {
        logoLayer.emitterPosition = CGPoint(x: position.x, y: position.y)
        view.layer.addSublayer(logoLayer)
    }
    
    private func stopLogoAnimation() {
        logoLayer.removeFromSuperlayer()
    }
    
}
