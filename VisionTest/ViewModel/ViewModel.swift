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

class ViewModel {
    
    var classificationSt: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    var pixelBuffer: PublishRelay<CVPixelBuffer> = PublishRelay<CVPixelBuffer>()
    
    
}
