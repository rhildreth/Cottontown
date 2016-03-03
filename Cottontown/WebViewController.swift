//
//  WebViewController.swift
//  Cottontown
//
//  Created by Ron Hildreth on 3/2/16.
//  Copyright © 2016 Tappdev.com. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: urlString)
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
        
    }

    @IBAction func done(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
