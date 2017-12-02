//
//  ViewController.swift
//  Socket_client_Demo
//
//  Created by Wilson on 2017/12/1.
//  Copyright © 2017年 Wilson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var retrieveLabel: UILabel!
    @IBOutlet weak var sendTextField: UITextField!

    var iStream:InputStream?=nil
    var oStream:OutputStream?=nil

    
    override func viewDidLoad() {
        super.viewDidLoad()

        Stream.getStreamsToHost(withName: "localhost", port:5000, inputStream: &iStream, outputStream: &oStream)
        
        iStream?.open()
        oStream?.open()
        
        DispatchQueue.global().async {
            
                self.retrieveData(available: { (string) in
                    DispatchQueue.main.async {
                        self.retrieveLabel.text=string
                    }
                })
        }
    }
    

    func retrieveData(available:(_ string:String?) -> Void) {
    
        var buff=Array(repeating: UInt8(0),count:1024)
        
        while true {
            if let n=iStream?.read(&buff, maxLength: 1024)
            {
                if(n<0)
                {
                    return
                }
                
                let data=Data(bytes:buff,count:n)
                let string=String(data:data,encoding:.utf8)
                available(string)
            }
        }
    
    }
    func send(_ string:String){
        
        var buff=Array(repeating: UInt8(0),count:1024)
        let  data=string.data(using: .utf8)
        
        data?.copyBytes(to: &buff,count:(data?.count)!)
        oStream?.write(buff, maxLength: (data?.count)!)
    }
    
    @IBAction func onSendClicked()
    {
        if let string=self.sendTextField.text
        {
            send(string)
        }
    }
    
    @IBAction func handleDismissKeyboard()
    {
        self.sendTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

