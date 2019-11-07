//
//  Report.swift
//  ClearScore
//
//  Created by Eric Sans Alvarez on 02/11/2019.
//  Copyright © 2019 Eric Sans Alvarez. All rights reserved.
//

import Foundation

struct Report: Decodable {
    
    let score: Int
    let maxScoreValue: Int
    let minScoreValue: Int
    let equifaxScoreBandDescription: String
    
}
