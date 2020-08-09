import Foundation

extension OrderedListMarkerFormat {
    func render(_ number: Int, prefix: String, suffix: String) -> String {
        switch self {
        case .lowercaseAlpha:
            return "\(prefix)\(number.asEnglishAlphabet.lowercased())\(suffix)"
        case .lowercaseHexadecimal:
            return "\(prefix)\(number.asHexadecimalString.lowercased())\(suffix)"
        case .lowercaseRoman:
            return "\(prefix)\(number.asRomanNumerals.lowercased())\(suffix)"
        case .octal:
            return "\(prefix)\(number.asOctalString)\(suffix)"
        case .arabicNumeral:
            return "\(prefix)\(number)\(suffix)"
        case .uppercaseAlpha:
            return "\(prefix)\(number.asEnglishAlphabet)\(suffix)"
        case .uppercaseHexadecimal:
            return "\(prefix)\(number.asHexadecimalString)\(suffix)"
        case .uppercaseRoman:
            return "\(prefix)\(number.asRomanNumerals)\(suffix)"
        }
    }
}

