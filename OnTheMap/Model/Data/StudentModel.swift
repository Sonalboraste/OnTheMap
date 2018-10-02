//
//  StudentModel.swift
//  OnTheMap
//
//  Created by Sonal on 9/30/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import Foundation
class StudentModel: NSObject
{
    
    // MARK: Global Variable
    var arrayOfStudentData = [StudentData]()
    
    class func sharedInstance() -> StudentModel {
        struct Singleton {
            static var sharedInstance = StudentModel()
        }
        return Singleton.sharedInstance
    }
}
