import Foundation

extension Int {
    var asRomanNumerals: String {
        var romanNumerals = ""
        
        var current = self
        while current > 0 {
            current = current.accumulateRomanNumeral(into: &romanNumerals)
        }

        return romanNumerals
    }
    
    var asEnglishAlphabet: String {
        let normalizedValue = self % Self.englishAlphabet.count
        return Self.englishAlphabet[normalizedValue]
    }
    
    var asOctalString: String {
        String(self, radix: 8, uppercase: true)
    }
    
    var asHexadecimalString: String {
        String(self, radix: 16, uppercase: true)
    }
}

private extension Int {
    static let englishAlphabet = [
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
        "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
    ]
    
    static let romanNumeralValues = [
        (1000, "M"),
        (900, "CM"),
        (500, "D"),
        (400, "CD"),
        (100, "C"),
        (90, "XC"),
        (50, "L"),
        (40, "XL"),
        (10, "X"),
        (9, "IX"),
        (5, "V"),
        (4, "IV"),
        (1, "I")
    ]
    
    func accumulateRomanNumeral(into sum: inout String) -> Int {
        guard let romanNumeralPair = Self.romanNumeralValues.first(where: { $0.0 <= self }) else {
            return 0 // done
        }
        
        sum += romanNumeralPair.1
        
        return self - romanNumeralPair.0
    }
}
