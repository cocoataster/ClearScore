//
//  DashboardViewModel.swift
//  ClearScore
//
//  Created by Eric Sans Alvarez on 02/11/2019.
//  Copyright © 2019 Eric Sans Alvarez. All rights reserved.
//

import Foundation

protocol DashboardViewModelDelegate: class {
    func didRequestCreditScore()
    func didGetCreditScore()
    func didGetError(_ error: ErrorType)
}

class DashboardViewModel {
    var message: String?
    var score: Int?
    var maxScore: Int?
    var maxScoreText: String?
    var minScore: Int?
    var bandDescription: String?
    
    let network: Network
    
    var delegate: DashboardViewModelDelegate?
    
    init(network: Network) {
        self.network = network
    }
    
    // Start API Call
    
    func getAccount() {
        // Advice View Controller network call just begin
        delegate?.didRequestCreditScore()
        
        network.getAccount { (reportData, error) in
            guard error == nil else {
                // Advice View Controller network call returned an error
                self.delegate?.didGetError(error!)
                return
            }
            
            if let report = reportData {
                // Set model with report data
                self.setModel(report)
                // Advice View Controller network call just finished successfully
                self.delegate?.didGetCreditScore()
            }
        }
    }
    
    func setModel(_ report: Report) {
        message = "Your credit score is"
        score = report.score
        maxScore = report.maxScoreValue
        maxScoreText = "out of \(report.maxScoreValue)"
        minScore = report.minScoreValue
        bandDescription = report.equifaxScoreBandDescription
    }
}
