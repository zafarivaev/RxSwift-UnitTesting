//
//  ViewModel.swift
//  RxSwift-Testing
//
//  Created by Zafar on 3/29/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import RxSwift
import RxCocoa

final class ViewModel {
    
    // MARK: - Input
    let didSelectFirst = BehaviorRelay(value: false)
    let didSelectSecond = BehaviorRelay(value: false)
    let didSelectThird = BehaviorRelay(value: false)
    
    // MARK: - Output
    var isFirstEnabled: Observable<Bool> {
        return Observable.combineLatest(didSelectFirst, didSelectSecond, didSelectThird) {
            if $0, !$1, !$2 {
                return $0
            }
            return false
        }
    }
    
    var isSecondEnabled: Observable<Bool> {
        return Observable
            .combineLatest(didSelectFirst, didSelectSecond, didSelectThird) {
                if $1, !$0, !$2 {
                    return $1
                }
                return false
        }
    }
    
    var isThirdEnabled: Observable<Bool> {
        return Observable
            .combineLatest(didSelectFirst, didSelectSecond, didSelectThird) {
                if $2, !$0, !$1 {
                    return $2
                }
                return false
        }
    }
}
