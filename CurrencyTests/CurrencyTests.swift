//
//  CurrencyTests.swift
//  CurrencyTests
//
//  Created by James Kong on 24/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import XCTest

import Reachability
@testable import Currency


class CurrencyTests: XCTestCase {
    
    var viewModel: CurrencyViewModel!
    
    
    override func setUp() {
        super.setUp()
        viewModel = CurrencyViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAPIManagerGetData () {
        let expectation = XCTestExpectation(description: "Download from forex")
        
        viewModel.requestData()
        viewModel.currencyRatesPublishSubject.subscribe { (currencyRates) in
            print(currencyRates)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func testAPIManagerGetObjects () {
        let expectation = XCTestExpectation(description: "Download from forex")
        
        viewModel.requestDatas(params: ["USDHKD", "USDJPY"])
        viewModel.currencyRatesPublishSubject.subscribe { (currencyRates) in
            XCTAssertNotNil(currencyRates)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func testConverterShouldThrowError () {
        let dic = ["rates": nil, "code": 200]
        let result = Converter.parseObject(dictionary: dic as [String : AnyObject], previous: [])
        switch(result) {
        case .failure(let error):
            print(error)
            XCTAssertNotNil(error)
            break
            
        case .success(_):
            break
        }
    }
    
    func testViewModelMethod () {
        let expectation = XCTestExpectation(description: "Fetch from coredata")
        viewModel.managedObjectContext.rx.entities(CurrencyRate.self, predicate: nil, sortDescriptors: nil)
            .subscribe(onNext: { currenctRates in
                XCTAssertNotNil(currenctRates)
                expectation.fulfill()
            }, onError: {error in
                
            }, onCompleted: {
                
            }){
                
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testSubArrayMethod () {
        let array = [1,2,3,4,5,6,7,8,9,10,11]
        let range = NSMakeRange(5, array.count)
        
        let expect = [6,7,8,9,10,11]
        XCTAssertEqual(viewModel.subArray(array: array, range:range), expect)
    }
    
    
    
}
