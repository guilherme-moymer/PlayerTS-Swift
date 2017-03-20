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
                let file : String = r.params[":file"]!
                let url = "https://s3-sa-east-1.amazonaws.com/moymer/\(file)"
                
                let info = self.getDataFromCache(url: url, filename: file)
                return HttpResponse.raw(200, "ok", info.0, {  writer in
                    try? writer.write(info.1)
                })
            }

        
        } catch {
            print("Server start error: \(error)")
        }
    }
    
    func getData(url: String) -> ([String:String], Data)
    {
        var h : [String:String]?
        var d : Data?
        let semaphore = DispatchSemaphore(value: 0)
        Alamofire.request(url, method: .get).responseData { (r) in
            h = r.response?.allHeaderFields as? [String : String]
            d = r.data!
            semaphore.signal()
            
        }
        semaphore.wait()
        
        return (h!,d!)
    }
    
    
    func getDataFromCache(url: String, filename: String) -> ([String:String], Data)
    {
        var h : [String:String]?
        var d : Data?
        let semaphore = DispatchSemaphore(value: 0)
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
     
        if FileManager.default.fileExists(atPath: filePath.path)
        {
            //get from local dir
            let data: Data? = try? Data(contentsOf: filePath)
            h = [:] // ["Content-Length": String(describing: data?.count)]
            d = data!
        } else  {
            //get from the cloud
            Alamofire.download(url, method: .get, to: { (tempUrl, tempResponse) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
             return (filePath,[])
            }).responseData { (downloadResponse) in
                let destUrl = downloadResponse.destinationURL
                let data: Data? = try? Data(contentsOf: destUrl!)
                h = [:] // ["Content-Length": String(describing: data?.count)]
                d = data!

                semaphore.signal()
            }
            semaphore.wait()
        }
        
        return (h!,d!)
    }

    
    
    func printServer() {
        
        Alamofire.request(defaultLocalHost+"/hello", method: .get).responseData { (response) in
           
            if let data = response.result.value, let string = String(data: data, encoding: String.Encoding.utf8) {
                print(string)
            }
        }
        
        
    }
}
