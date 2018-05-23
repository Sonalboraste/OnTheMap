//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Sonal on 5/3/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void)
{
    DispatchQueue.main.async
    {
        updates()
    }
}
