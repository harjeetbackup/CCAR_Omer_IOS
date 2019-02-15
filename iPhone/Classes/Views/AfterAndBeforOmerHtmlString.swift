//
//  AfterAndBeforOmerHtmlString.swift
//  Omer_Flash_Card
//
//  Created by Mahadev Prasad on 2/15/19.
//

import UIKit

class AfterAndBeforOmerHtmlString: NSObject {
    
    static func htmlString() -> String {
        var html = ""
        
        html = html + "<html>"
        html = html + "<head>"
        html = html + "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>"
        html = html + "<link rel=\"stylesheet\" type=\"text/css\" href=\"~/dCommon.css\"/>"
        html = html + "<link rel=\"stylesheet\" type=\"text/css\" href=\"~/dBack.css\"/>"
        html = html + "<link rel=\"stylesheet\" type=\"text/css\" media=\"all and (orientation:portrait)\" href=\"~/dBackP.css\" />"
        html = html + "<link rel=\"stylesheet\" type=\"text/css\" media=\"all and (orientation:landscape)\" href=\"~/dBackL.css\" />"
        html = html + "<style type=\"text/css\">"
        html = html + "table.dContents td{text-align:left;}"
        
        html = html + "p.item{ position:relative;margin-left:4em; }"
        
        html = html + "p.itemIndentLevel1{margin-left:6em;}"
        
        html = html + "p.item img.itemIcon{ position:absolute;left:-2.5em;width:2em;height:2em;}"
        
        html = html + "table{font-size:1em;}"
        
        html = html + "</style>"
        
        html = html + "</head>"
        
        html = html + "<body class=\"dWeek2A\" style=\"background:none;\">"
        html = html + "<div class=\"dOuterWrap\"></div>"
        
        html = html + "<div class=\"dOuter\" style=\"height:auto;\">"
        html = html + "<div class=\"dInner\" style=\"height:auto;\">"
        html = html + "<div class=\"dContentsBox\" style=\"height:auto;overflow-y:none;\">"
        html = html + "<table class=\"dContents\" style=\"height:95%;\"><tr><td>"
        
        let startDate = "aaaaaaaaaaaaaa"
        let endDate = ""
        
        html = html + "It's not currently the time to count the Omer.  Feel free to browse through the cards until then.  This year, the dates of the Omer are: \(startDate) through \(endDate). You can set an alarm to remember to count by tapping the alarm bell on the main menu screen at the bottom"
        
        html = html + "</td></tr></table>"
        html = html + "</div>"
        html = html + "</div>"
        html = html + "</div>"
        html = html + "</body>"
        html = html + "</html>"
        return html
    }
}









