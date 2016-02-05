//
//  StringToNumbers.swift
//  String Manipulations
//
//  Created by Edoardo Franco Vianelli on 2/5/16.
//  Copyright © 2016 Edoardo Franco Vianelli. All rights reserved.
//

import Foundation

extension String
{
    func PositiveInteger(ignoreSpaces : Bool) -> Int? //converts a string to a positive integer
        //if possible
    {
        var temp = self
        if ignoreSpaces { temp = self.stringByReplacingOccurrencesOfString(" ", withString: "") }
        var value = 0

        let NumberMappings : Dictionary<Character, Int> = ["1" : 1, "2" : 2, "3" : 3, "4" : 4, "5" : 5, "6" : 6, "7" : 7, "8" : 8, "9" : 9, "0" : 0]

        for current in temp.characters
        {
            if let val = NumberMappings[current]
            {
                value += val
                value *= 10
            }
            else
            {
                return nil
            }
        }

        return value
    }

    func NegativeInteger(ignoreSpaces : Bool) -> Int?//converts a string to a negative or positive integer
        //if possible
    {
        var temp = self
        if ignoreSpaces { temp = self.stringByReplacingOccurrencesOfString(" ", withString: "") }

        if temp.characters.first == "-"
        {
            if let val = temp.substringFromIndex(temp.startIndex.successor()).PositiveInteger(ignoreSpaces)
            {
                return -val
            }
            return nil
        }

        return temp.PositiveInteger(ignoreSpaces)
    }

    func PositiveDouble(ignoreSpaces : Bool) -> Double?
        //converts a string to a positive double
        //if possible
    {
        var temp = self
        if ignoreSpaces { temp = self.stringByReplacingOccurrencesOfString(" ", withString: "") }

        var value = 0.0
        var trailing = 0.0
        var divisor = 10.0
        var after_dot = false

        let NumberMappings : Dictionary<Character, Int> = ["1" : 1, "2" : 2, "3" : 3, "4" : 4, "5" : 5, "6" : 6, "7" : 7, "8" : 8, "9" : 9, "0" : 0]

        for current in temp.characters
        {
            if let current_value = NumberMappings[current]
            {
                if !after_dot
                {
                    value *= 10
                    value += Double(current_value)
                }
                else
                {
                    trailing += Double(current_value)
                    trailing *= 10
                    divisor *= 10
                }
            }
            else if current == "."
            {
                after_dot = true
            }
            else { return nil }
        }

        return value + trailing / divisor
    }

    func NegativeDouble(ignoreSpaces : Bool) -> Double?
        //converts a string to a positive or negative double
        //if possible
    {
        var temp = self
        if ignoreSpaces { temp = self.stringByReplacingOccurrencesOfString(" ", withString: "") }

        if temp.characters.first == "-"
        {
            if let val = temp.substringFromIndex(temp.startIndex.successor()).PositiveDouble(ignoreSpaces)
            {
                return -val
            }
        }

        return temp.PositiveDouble(ignoreSpaces)
    }

    func BigDouble(ignoreSpaces : Bool) -> Double?
        //converts a string to a positive or negative double
        //both small and bigger numbers with scientific notation
        //if possible
    {
        var temp = self
        if ignoreSpaces { temp = self.stringByReplacingOccurrencesOfString(" ", withString: "") }

        var value = 0.0
        var trailing = 0.0
        var divisor = 10.0
        var after_dot = false

        let NumberMappings : Dictionary<Character, Int> = ["1" : 1, "2" : 2, "3" : 3, "4" : 4, "5" : 5, "6" : 6, "7" : 7, "8" : 8, "9" : 9, "0" : 0]

        for (i,current) in temp.characters.enumerate()
        {
            if let current_value = NumberMappings[current]
            {
                if !after_dot
                {
                    value *= 10
                    value += Double(current_value)
                }
                else
                {
                    trailing += Double(current_value)
                    trailing *= 10
                    divisor *= 10
                }
            }
            else if current == "." && !after_dot
            {
                after_dot = true
            }
            else if current == "e".lowercaseString.characters.first!
            {
                var next_part = self.substringFromIndex(self.startIndex.advancedBy(i+1))
                if next_part.characters.first == "+"
                {
                    next_part.removeAtIndex(next_part.startIndex)
                }
                else if next_part.characters.first == " "
                {
                    return nil
                }
                if let successor = next_part.NegativeDouble(ignoreSpaces)
                {
                    let base = (value + trailing / divisor)
                    return base * pow(10.0,successor)
                }
                return nil
            }else { return nil }
        }

        return value + trailing / divisor
    }
}