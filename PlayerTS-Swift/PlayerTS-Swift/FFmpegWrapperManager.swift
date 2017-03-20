//
//  FFmpegWrapperManager.swift
//  PlayerTS-Swift
//
//  Created by Guilherme Braga on 17/03/17.
//  Copyright © 2017 Moymer. All rights reserved.
//

import UIKit
import Converter

class FFmpegWrapperManager: NSObject {
    
    private let inputFilePath: String
    
    private let wrapper = FFmpegWrapper()
    
    private let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/MyFolder")
    
    private let fm = FileManager.default
    
    private let outputFilePath: String
    
    required init(inputFilePath: String) {
        
        self.inputFilePath = inputFilePath
        self.outputFilePath = self.directory.appending("/teste.m3u8")
        
        super.init()
    }
    
    func convertMp4ToTSVideoFormat(clearDirectory: Bool, completionBlock: @escaping (Bool, Error?) -> Swift.Void) {
        
        if clearDirectory {
            self.clearDirectory()
        }
        
        if !fm.fileExists(atPath: self.directory) {
            try? fm.createDirectory(atPath: self.directory, withIntermediateDirectories: false, attributes: [:])
        }
        
        wrapper.convertInputPath(inputFilePath, outputPath: outputFilePath, options: [:], progressBlock: { (_, _, _) in
            
        }, completionBlock: completionBlock)
    }
    
    func clearDirectory() {
        
        guard let contentsOfDirectory = try? fm.contentsOfDirectory(atPath: self.directory) else {
            return
        }
        
        for file in contentsOfDirectory {
            try? fm.removeItem(atPath: self.directory+file)
        }
    }
    
    func getm3u8FilePath() -> String {
        return outputFilePath
    }
}
