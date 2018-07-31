//
//  CurrentAccount.swift
//  OnTheMap
//
//  Created by Sonal on 7/1/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import Foundation

final class CurrentAccount
{
    
    // MARK: Properties
    static var accountRegistered : Bool = false
    
    static var accountKey : String = ""
    
    private init(dictionary: [String:AnyObject])
    {
        if let resValue = dictionary[UdacityClient.JSONResponseKeys.AccountRegistered] as? Bool
        {
            CurrentAccount.accountRegistered = resValue
        }
        else
        {
            CurrentAccount.accountRegistered  = false
        }
        
        if let resValue = dictionary[UdacityClient.JSONResponseKeys.AccountKey] as? String
        {
            CurrentAccount.accountKey = resValue
        }
        else
        {
            CurrentAccount.accountKey = ""
        }
    }
    
    static func accountFromResult(_ result: [String:AnyObject])->CurrentAccount
    {
        return CurrentAccount(dictionary: result)
    }
    
}
