//
//  ViewController.swift
//  VisionTest
//
//  Created by 福山帆士 on 2020/08/07.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import ARKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    private let disposeBug = DisposeBag()
    private let viewModel = ViewModel()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).withAlphaComponent(0.7)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.session.delegate = self
        
        setupUI()
        
        setupTextlabelObservable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func setupUI() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        let textLabelConstraints = [
            textLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            textLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(textLabelConstraints)
    }
    
    func setupTextlabelObservable() {
        viewModel.classificationSt.asObservable().bind(to: textLabel.rx.text).disposed(by: disposeBug)
    }
    
    func addPixelBuffer(pixelBuffr: CVPixelBuffer) {
        viewModel.pixelBuffer.accept(pixelBuffr)
    }
}

extension ViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let frame = sceneView.session.currentFrame else { return }
        let pixelBuffer = frame.capturedImage
        
        addPixelBuffer(pixelBuffr: pixelBuffer)
    }
}
