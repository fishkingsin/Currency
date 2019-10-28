//
//  CurrencyTests.swift
//  CurrencyTests
//
//  Created by James Kong on 24/10/2019.
//  Copyright © 2019 James Kong. All rights reserved.
//

import XCTest
import OCMock
import Reachability
@testable import Currency


class CurrencyTests: XCTestCase {

    var dataSource: CurrencyDataSource!
    var viewModel: CurrencyViewModel!

    
    override func setUp() {
        super.setUp()
        dataSource = CurrencyDataSource()
               
        viewModel = CurrencyViewModel(dataSource: dataSource)
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
        
        APIManager.requestData(url:"", method: .get, parameters: nil, completion: { (result) in
            XCTAssertNotNil(result, "No data was downloaded.")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func testAPIManagerGetObjects () {
        let expectation = XCTestExpectation(description: "Download from forex")
        
        viewModel.requestDatas(params: ["USDHKD", "USDJPY"])
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    
}
