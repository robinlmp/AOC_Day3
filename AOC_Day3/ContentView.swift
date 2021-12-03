//
//  ContentView.swift
//  AOC_Day3
//
//  Created by Robin Phillips on 03/12/2021.
//

import SwiftUI

struct ContentView: View {
    
    let example = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"""
    
    var body: some View {
        VStack {
            Text("Part 1: \(verticalBinaryTotals(fileName: "input-3") ?? 0)")
                .padding()
            Text("Part 2: \(processingResults(fileName: "input-3") ?? 0)")
                .padding()
        }
    }
    
    
    func processingResults(fileName: String) -> Int? {
        guard let rows = rowsAsBinary(fileName: "input-3") else { return nil }
        var oxygenRow = rows
        var c02Row = rows
        
        for i in 0..<rows[0].count {
            oxygenRow = filtering(rows: oxygenRow, index: i, oxygen: true) ?? []
            if oxygenRow.count == 1 { break }
        }
        
        for i in 0..<rows[0].count {
            c02Row = filtering(rows: c02Row, index: i, oxygen: false) ?? []
            if c02Row.count == 1 { break }
        }
        
        let oxygenInt = binaryToInt(binaryString: binaryToString(binaryRow: oxygenRow.flatMap { $0 }))
        let c02Int = binaryToInt(binaryString: binaryToString(binaryRow: c02Row.flatMap { $0 }))
        return oxygenInt * c02Int
    }
    
    
    func filtering(rows: [[Int]]?, index: Int, oxygen: Bool) -> [[Int]]? {
        guard let rows = rows else { return nil }
        var editedRows: [[Int]] = []
        var count0 = 0
        var count1 = 0
        
        for row in rows {
            if row[index] == 0 {
                count0 += 1
            } else {
                count1 += 1
            }
        }
        
        for i in 0..<rows.count {
            if (oxygen && count1 >= count0) || (!oxygen && count0 > count1) {
                if rows[i][index] == 1 {
                    editedRows.append(rows[i])
                }
            } else if rows[i][index] == 0 {
                editedRows.append(rows[i])
            }
        }
        return editedRows
    }
    
    func loadFile(fileName: String) -> String? {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: "txt"),
              let contents = try? String(contentsOfFile: filepath) else { return nil }
        return contents
    }
    
    func processFile(contents: String) -> [String] {
        return contents.components(separatedBy: "\n").filter { $0 != "" }
    }
    
    func makeBinary(input: String) -> [Int] {
        var binaryArray: [Int] = []
        
        for character in input {
            if let digit = Int(character.description) {
                binaryArray.append(digit)
            }
        }
        return binaryArray
    }
    
    
    func rowsAsBinary(fileName: String) -> [[Int]]? {
        guard let contents = loadFile(fileName: "input-3") else { return nil }
        let components = processFile(contents: contents)
        //        let components = processFile(contents: example)
        let componentAsBinary = components.map { makeBinary(input: $0) }
        return componentAsBinary
    }
    
    func binaryToString(binaryRow: [Int]) -> String {
        var binaryString = ""
        for binaryDigit in binaryRow {
            binaryString += String(binaryDigit)
        }
        return binaryString
    }
    
    
    func verticalBinaryTotals(fileName: String) -> Int? {
        guard let contents = loadFile(fileName: "input-3") else { return nil }
        let components = processFile(contents: contents)
        let totalRows = components.count
        var totals: [Int] = [0,0,0, 0,0,0, 0,0,0, 0,0,0]
        var binaryResult1 = ""
        var binaryResult2 = ""
        
        for component in components {
            let binary = makeBinary(input: component)
            
            for i in 0..<binary.count {
                totals[i] += binary[i]
            }
        }

        for total in totals {
            binaryResult1 += String(averagedToBinary(input: total, divisor: totalRows))
            
            if averagedToBinary(input: total, divisor: totalRows) == 0 {
                binaryResult2 += "1"
            } else {
                binaryResult2 += "0"
            }
        }
        return binaryToInt(binaryString: binaryResult1) * binaryToInt(binaryString: binaryResult2)
    }
    
    
    func averagedToBinary(input: Int, divisor: Int) -> Int {
        let average: Double = Double(input) / Double(divisor)
        if average > 0.5 {
            return 1
        } else {
            return 0
        }
    }
    
    
    func binaryToInt(binaryString: String) -> Int {
        return Int(strtoul(binaryString, nil, 2))
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
