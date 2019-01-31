import Foundation

struct API {
    private init(){}
    static let BaseURL = "https://bnet.i-partner.ru/testAPI/"
    static let Token = "lxqEVe6-uB-FMmG8jZ"
    static let Session = UserDefaults.standard.string(forKey: "session") ?? ""
}


