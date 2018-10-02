//
//  SignUpViewController.swift
//  OnTheMap
//
//  Created by Sonal on 9/30/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import Foundation
import WebKit

class SignUpViewController: UIViewController
{   
    
    // MARK: Outlets
    
    @IBOutlet weak var webViewUdacitySite: WKWebView!
    
    @IBOutlet weak var waitCursorSpinnerToLoadSignUpPage: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        waitCursorSpinnerToLoadSignUpPage.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        waitCursorSpinnerToLoadSignUpPage.stopAnimating()
        waitCursorSpinnerToLoadSignUpPage.hidesWhenStopped = true
        
        let url = URL(string: "https://auth.udacity.com/sign-up")
        let request = URLRequest(url: url!)
        webViewUdacitySite.load(request)
    }
    
}
