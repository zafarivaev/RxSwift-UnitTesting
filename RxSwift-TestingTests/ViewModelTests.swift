//
//  ViewModelTests.swift
//  RxSwift-TestingTests
//
//  Created by Zafar on 3/30/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import RxSwift_Testing

class ViewModelTests: XCTestCase {
    var disposeBag: DisposeBag!
    var viewModel: ViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    var testScheduler: TestScheduler!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        viewModel = ViewModel()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        scheduler = nil
        testScheduler = nil
        super.tearDown()
    }
    
    // MARK: - RxTest
    func testWhenInitialStateAllButtonsAreDisabled() {
        let isFirstEnabled = testScheduler.createObserver(Bool.self)
        let isSecondEnabled = testScheduler.createObserver(Bool.self)
        let isThirdEnabled = testScheduler.createObserver(Bool.self)
        
        viewModel.isFirstEnabled
            .bind(to: isFirstEnabled)
            .disposed(by: DisposeBag())
        
        viewModel.isSecondEnabled
            .bind(to: isSecondEnabled)
            .disposed(by: DisposeBag())
        
        viewModel.isThirdEnabled
            .bind(to: isThirdEnabled)
            .disposed(by: DisposeBag())
        
        XCTAssertEqual(isFirstEnabled.events, [.next(0, false)])
        XCTAssertEqual(isSecondEnabled.events, [.next(0, false)])
        XCTAssertEqual(isThirdEnabled.events, [.next(0, false)])
    }
    
    // MARK: - RxBlocking
    func testWhenFirstIsSelectedSecondAndThirdAreDisabled() {
        let isFirstEnabled = viewModel.isFirstEnabled.subscribeOn(scheduler)
        let isSecondEnabled = viewModel.isSecondEnabled.subscribeOn(scheduler)
        let isThirdEnabled = viewModel.isThirdEnabled.subscribeOn(scheduler)
        
        // When
        viewModel.didSelectFirst.accept(true)
        viewModel.didSelectSecond.accept(false)
        viewModel.didSelectThird.accept(false)
        
        // Then
        XCTAssertEqual([try isFirstEnabled.toBlocking().first(),
                        try isSecondEnabled.toBlocking().first(),
                        try isThirdEnabled.toBlocking().first()],
                       [
                        true,
                        false,
                        false
        ])
    }
    
    func testWhenSecondIsSelectedFirstAndThirdAreDisabled() {
        let isFirstEnabled = viewModel.isFirstEnabled.subscribeOn(scheduler)
        let isSecondEnabled = viewModel.isSecondEnabled.subscribeOn(scheduler)
        let isThirdEnabled = viewModel.isThirdEnabled.subscribeOn(scheduler)
        
        // When
        viewModel.didSelectSecond.accept(true)
        viewModel.didSelectFirst.accept(false)
        viewModel.didSelectThird.accept(false)
        
        // Then
        XCTAssertEqual([try isFirstEnabled.toBlocking().first(),
                        try isSecondEnabled.toBlocking().first(),
                        try isThirdEnabled.toBlocking().first()],
                       [
                        false,
                        true,
                        false
        ])
    }
    
    func testWhenFirstAndThenThirdAreSelected_firstAndSecondAreDisabled() {
        let isFirstEnabled = viewModel.isFirstEnabled.subscribeOn(scheduler)
        let isSecondEnabled = viewModel.isSecondEnabled.subscribeOn(scheduler)
        let isThirdEnabled = viewModel.isThirdEnabled.subscribeOn(scheduler)
        
        // When
        viewModel.didSelectFirst.accept(true)
        viewModel.didSelectSecond.accept(false)
        viewModel.didSelectThird.accept(false)
        
        viewModel.didSelectThird.accept(true)
        viewModel.didSelectFirst.accept(false)
        viewModel.didSelectSecond.accept(false)
        
        // Then
        XCTAssertEqual([try isFirstEnabled.toBlocking().first(),
                        try isSecondEnabled.toBlocking().first(),
                        try isThirdEnabled.toBlocking().first()],
                       [
                        false,
                        false,
                        true
        ])
    }


}
