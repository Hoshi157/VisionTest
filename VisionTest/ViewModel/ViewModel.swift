//
//  ViewModel.swift
//  VisionTest
//
//  Created by 福山帆士 on 2020/08/07.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Vision

class ViewModel {
    
    private let classificationSubject = PublishSubject<String>()
    
    var classificationSt: Observable<String> {
        return classificationSubject
    }
    
    func classification(text: String) {
        classificationSubject.onNext(text)
    }
    
    func pixelBuffer(pixelBuffer: CVPixelBuffer) {
        initializationModel(pixelBuffer: pixelBuffer)
    }
    
    
    private func initializationModel(pixelBuffer: CVPixelBuffer) {
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            print("modelの初期化し失敗")
            return
        }
        
        imageDetectionRequest(model: model, completion: { [unowned self] request in
            guard let _request = request else { return }
            self.executionRequest(request: _request, pixelBuffer: pixelBuffer)
        })
    }
    
    private func imageDetectionRequest(model: VNCoreMLModel, completion: @escaping (_ request: VNCoreMLRequest?) -> Void) {
        let request = VNCoreMLRequest(model: model) { [unowned self] (request: VNRequest, error: Error?) in
            if let error = error {
                print(error.localizedDescription, "model request エラー")
                completion(nil)
            }else {
                guard let requests = request.results as? [VNClassificationObservation] else { return }
                
                let classificationText = requests.prefix(3).compactMap {
                    "\(Int($0.confidence * 100))% \($0.identifier.components(separatedBy: ","))"
                }.joined(separator: "\n")
                
                self.classification(text: classificationText)
            }
        }
        completion(request)
    }
    
    private func executionRequest(request: VNCoreMLRequest, pixelBuffer: CVPixelBuffer) {
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
}
