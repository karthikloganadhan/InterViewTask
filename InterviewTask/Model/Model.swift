//
//  Model.swift
//  InterviewTask
//
//  Created by Admin on 06/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation


struct FactsResponse: Codable{
    var title: String?
    var rows: [Rows]
    
}

struct Rows: Codable {
    let title: String?
    let description: String?
    let imageHref: String?
    
}


