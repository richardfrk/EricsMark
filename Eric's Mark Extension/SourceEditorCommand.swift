//
//  SourceEditorCommand.swift
//  Eric's Mark Extension
//
//  Created by Richard Frank on 25/10/16.
//  Copyright © 2016 Richard Frank. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        var lineClassMark:Int?
        var linePropertieMark:Int?
        var lineIBOutletMark:Int?
        var lineSuperMethodMark:Int?
        var lineIBActionMark:Int?
        var linePrivateMethodMark:Int?
        var lineExtensionMark:Int?
        
        for i in 0..<invocation.buffer.lines.count {
            
            let line = invocation.buffer.lines[i] as! String
            
            if line.contains("class") {
                lineClassMark = i
            }
            
            if (line.contains("var") || line.contains("let")) && linePropertieMark == nil {
                
                if line.contains("IBOutlet") && lineIBOutletMark == nil  {
                    
                    invocation.buffer.lines.insert("    //MARK: - IBOutlets", at: i)
                    lineIBOutletMark = i
                    linePropertieMark = 0
                    
                } else {
                    
                    invocation.buffer.lines.insert("    //MARK: - Properties", at: i)
                    linePropertieMark = i
                    
                }
                
            }
            
            if line.contains("IBOutlet") && lineIBOutletMark == nil  {
                
                invocation.buffer.lines.insert("    //MARK: - IBOutlets", at: i)
                lineIBOutletMark = i
                
            }
            
            if line.contains("super") && lineSuperMethodMark == nil  {
                
                invocation.buffer.lines.insert("    //MARK: - Super Methods", at: i-1)
                lineSuperMethodMark = i-1
                linePropertieMark = 0
                
            }
            
            if line.contains("IBAction") && lineIBActionMark == nil  {
                
                invocation.buffer.lines.insert("    //MARK: - IBActions", at: i)
                lineIBActionMark = i
                
            }
            
            if line.contains("private func") && linePrivateMethodMark == nil  {
                
                invocation.buffer.lines.insert("    //MARK: - Private Methods", at: i)
                linePrivateMethodMark = i
                
            }
            
            if line.contains("extension") && lineExtensionMark == nil {
                
                invocation.buffer.lines.insert("    //MARK: - Extensions", at: i)
                lineExtensionMark = i
                
            }
            
        }
        
        if linePropertieMark == 0 && lineIBOutletMark == nil {
            
            invocation.buffer.lines.insert("    //MARK: - Properties", at: lineClassMark!+2)
            linePropertieMark = lineClassMark!+2
            
            invocation.buffer.lines.insert("    //MARK: - IBOutlets", at: lineClassMark!+3)
            lineIBOutletMark = lineClassMark!+3
            
            invocation.buffer.lines.insert("", at: lineIBOutletMark!)
            invocation.buffer.lines.insert("", at: lineIBOutletMark!)
            
            
            
        }
        
        completionHandler(nil)
    }
    
}

