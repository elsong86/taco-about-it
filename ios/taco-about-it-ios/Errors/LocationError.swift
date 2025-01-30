import Foundation

enum LocationError: Error {
    case locationNotAvailable
    case locationAccessDenied
    case unknown(Error)
}
