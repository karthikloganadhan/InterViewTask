//
//  UIView+Extension.swift
//  InterviewTask
//
//  Created by Admin on 06/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

extension UIView{
    func pin(_ superView: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
}
