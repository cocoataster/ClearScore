//
//  DashboardViewModelTests.swift
//  ClearScoreTests
//
//  Created by Eric Sans Alvarez on 04/11/2019.
//  Copyright © 2019 Eric Sans Alvarez. All rights reserved.
//

import XCTest
@testable import ClearScore

class DashboardViewModelTests: XCTestCase {
    
    var report: Report!
    var account: Account!
    
    var dashboardViewModel: DashboardViewModel!

    override func setUp() {
        report = Report(score: 690, maxScoreValue: 700, minScoreValue: 0, equifaxScoreBandDescription: "Oh Yeah!")
        account = Account(creditReportInfo: report)
        
        dashboardViewModel = DashboardViewModel(network: Network.manager)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReportExistence() {
        XCTAssertNotNil(report)
    }
    
    func testDashboardExistence() {
        XCTAssertNotNil(dashboardViewModel)
    }
    
    func testDecodeModels() {
        if let path =
            Bundle(for: DashboardViewModelTests.self).path(forResource: "account", ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                
                let account = try JSONDecoder().decode(Account.self, from: data)
                
                self.report = account.creditReportInfo
                XCTAssertNotNil(report)
            } catch let error {
                print(error)
                XCTFail()
            }
        }
    }
    
    func testModelProperties() {
        dashboardViewModel.setModel(self.report)
        
        XCTAssertEqual(dashboardViewModel.message, "Your credit score is")
        XCTAssertEqual(dashboardViewModel.score, report.score)
        XCTAssertEqual(dashboardViewModel.maxScore, report.maxScoreValue)
        XCTAssertEqual(dashboardViewModel.maxScoreText, "out of \(report.maxScoreValue)")
        XCTAssertEqual(dashboardViewModel.bandDescription, report.equifaxScoreBandDescription)
    }
    
    func testNetworkManager() {
        
        let expect = expectation(description: "Should get data")
        
        dashboardViewModel.network.getAccount { (report, error) in
            XCTAssertNil(error, "Unexpected error occurred: \(error!.localizedDescription)")
            XCTAssertNotNil(report, "Model not returned")
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Test time out. \(error!.localizedDescription)")
        }
    }
    
}
