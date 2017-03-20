//
//  LocalServerManager.swift
//  PlayerTS-Swift
//
//  Created by Guilherme Braga on 17/03/17.
//  Copyright © 2017 Moymer. All rights reserved.
//

import UIKit
import Swifter
import Alamofire

class LocalServerManager: NSObject {
    
    static let sharedManager = LocalServerManager()
    
    private var server = HttpServer()
    
    private let defaultLocalHost = "http://localhost:8080"
    
    func start() {
        
        do {
            let server = demoServer(Bundle.main.resourcePath!)
            self.server = server
            try self.server.start()
         
            server.GET["/moymer/gui-garotinha/:file"] = { r in
                
                print("Path to: \(r.path)")
                  print("Params: \(r.params[":file"])")
                let file : String = r.params[":file"]!
                let url = "https://s3-sa-east-1.amazonaws.com/moymer/\(file)"

              
               return  HttpResponse.raw(200, "OK", nil, {
                
                let writer = $0
                
                Alamofire.request(url, method: .get).stream(closure: { (data) in
                    
                        try? writer.write(data)
                })
 
                     /*Alamofire.request(url, method: .get).responseData { (response) in
                     
                      let data = response.result.value
                        
                        try? writer.write(data!)
                    }*/
                })
     
                
             // return .movedPermanently("https://s3-sa-east-1.amazonaws.com/moymer/garotinhaDance_index.m3u8")
            }
            
//            server.GET["/hello"] = { .ok(.text("You asked for \($0)")) }
            
        } catch {
            print("Server start error: \(error)")
        }
    }
    
    func share(filePath: String) {
        
    }
    
    func printServer() {
        
        Alamofire.request(defaultLocalHost+"/hello", method: .get).responseData { (response) in
           
            if let data = response.result.value, let string = String(data: data, encoding: String.Encoding.utf8) {
                print(string)
            }
        }
        
        
    }
}
