import Foundation

extension OrderedListMarkerFormat {
    func render(_ number: Int, separator: String) -> String {
        switch self {
        case .lowercaseAlpha:
            return "\(number.asEnglishAlphabet.lowercased())\(separator)"
        case .lowercaseHexadecimal:
            return "\(number.asHexadecimalString.lowercased())\(separator)"
        case .lowercaseRoman:
            return "\(number.asRomanNumerals.lowercased())\(separator)"
        case .octal:
            return "\(number.asRomanNumerals.lowercased())\(separator)"
        case .arabicNumeral:
            return "\(number)\(separator)"
        case .uppercaseAlpha:
            return "\(number.asEnglishAlphabet)\(separator)"
        case .uppercaseHexadecimal:
            return "\(number.asHexadecimalString)\(separator)"
        case .uppercaseRoman:
            return "\(number.asRomanNumerals)\(separator)"
        }
    }
}

