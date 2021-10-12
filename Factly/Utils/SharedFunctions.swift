//
//  SharedFunctions.swift
//  Factly
//
//  Created by Moshkina on 11.10.2021.
//  Copyright © 2021 Joey Tawadrous. All rights reserved.
//

import UIKit

class SharedFunctions {
    static let shared = SharedFunctions()
    
    /* MARK: Core Functionality
    /////////////////////////////////////////// */
//    func pullFact() {
//        let url = "https://opentdb.com/api.php?amount=1&type=multiple"
//        Utils.getFact(url, callback: {(params: String, urlContents: String) -> Void in
//            if urlContents.characters.count > 5 {
//                DispatchQueue.main.async(execute: {
//                    // Get data
//                    let result = (urlContents.parseJSONString.value(forKey: "results")! as! NSArray)[0] as! NSDictionary
//                    var question = result.value(forKey: "question")! as! String
//                    var answer = result.value(forKey: "correct_answer")! as! String
//                    question = question.replacingOccurrences(of: "&quot;", with: "", options: .literal, range: nil)
//                    answer = answer.replacingOccurrences(of: "&quot;", with: "", options: .literal, range: nil)
//                    question = question.replacingOccurrences(of: "&ldquo;", with: "", options: .literal, range: nil)
//                    answer = answer.replacingOccurrences(of: "&rdquo;", with: "", options: .literal, range: nil)
//                    question = question.removingPercentEncoding!
//                    answer = answer.removingPercentEncoding!
//                    
////                    UserDefaults.standard.set(question, forKey: Constants.Defaults.LATEST_FACT_QUESTION)
////                    UserDefaults.standard.set(answer, forKey: Constants.Defaults.LATEST_FACT_ANSWER)
//                    UserDefaults(suiteName: "group.com.hirerussians.factly")!.set(question, forKey: Constants.Defaults.LATEST_FACT_QUESTION)
//                    UserDefaults(suiteName: "group.com.hirerussians.factly")!.set(answer, forKey: Constants.Defaults.LATEST_FACT_ANSWER)
//                })
//            }
//        })
//    }
}
