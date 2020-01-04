//
//  ViewController.swift
//  CircularLoader
//
//  Created by Julio Collado on 1/3/20.
//  Copyright © 2020 Julio Collado. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let urlString = "https://www.quintic.com/software/sample_videos/Treadmill%20Running%20500fps.avi"
    let shapeLayer = CAShapeLayer()
    var downloadTask: URLSessionDownloadTask?
    var pursatingLayer: CAShapeLayer!
    
    let percentegeLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.backgroundColor
        drawLoaderCircle()
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeGround), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleEnterForeGround() {
        animatePulsatingLayer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func drawLoaderCircle() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        drawPursatingLayer(from: circularPath)
        drawTrackLayer(from: circularPath)
        drawShapeLayer(from: circularPath)
        drawPercentegeLabel()
    }
    
    private func drawPercentegeLabel() {
        view.addSubview(percentegeLabel)
        percentegeLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentegeLabel.center = view.center
    }
    
    private func drawPursatingLayer(from bezierPath: UIBezierPath) {
        pursatingLayer = CAShapeLayer()
        pursatingLayer.path = bezierPath.cgPath
        pursatingLayer.fillColor = UIColor.pulsatingFillColor.cgColor
        pursatingLayer.position = view.center
        
        view.layer.addSublayer(pursatingLayer)
        animatePulsatingLayer()
    }
    
    private func drawShapeLayer(from bezierPath: UIBezierPath) {
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = UIColor.outlineStrokeColor.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func drawTrackLayer(from bezierPath: UIBezierPath) {
        let trackLayer = CAShapeLayer()
        trackLayer.path = bezierPath.cgPath
        trackLayer.strokeColor = UIColor.trackStrokeColor.cgColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.backgroundColor.cgColor
        trackLayer.lineCap = .round
        trackLayer.position = view.center
        
        view.layer.addSublayer(trackLayer)
    }
    
    private func animatePulsatingLayer() {
        let basicAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        basicAnimation.toValue = 1.3
        basicAnimation.duration = 0.8
        basicAnimation.autoreverses = true
        basicAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        basicAnimation.repeatCount = Float.infinity
        pursatingLayer.add(basicAnimation, forKey: "pulsing")
    }
    
    @objc private func handleTap() {
        guard let taskState = downloadTask?.state else {
            beginDowloadingFile()
            return
        }
        switch taskState {
        case .running:
            downloadTask?.suspend()
        case .suspended:
            downloadTask?.resume()
        case .canceling:
            break
        case .completed:
            break
        @unknown default:
            break
        }
    }
    
    private func beginDowloadingFile() {
        shapeLayer.strokeEnd = 0
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else {
            return
        }
        downloadTask = urlSession.downloadTask(with: url)
        downloadTask?.resume()
    }
    
    
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished Downloading File")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progressPercentege =  CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.shapeLayer.strokeEnd = progressPercentege
            self.percentegeLabel.text = "\(Int(progressPercentege * 100))%"
        }
        
    }
}

//    fileprivate func animateCircle() {
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.toValue = 1
//        basicAnimation.duration = 2
//        basicAnimation.fillMode = .forwards
//        basicAnimatio n.isRemovedOnCompletion = false
//        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
//    }

