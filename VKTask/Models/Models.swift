import Foundation

//MARK: Network models

struct ServiceRequestModel: Decodable {
    let body: ServiceListModel
}

struct ServiceListModel: Decodable {
    let services: [ServiceModel]
}

struct ServiceModel: Decodable {
    let name: String
    let description: String
    let link: URL
    let icon_url: URL
}

//MARK: Display model

final class ServiceDisplayModel {
    let name: String
    let description: String
    let link: URL
    let icon_url: URL
    var iconData: Data?
    
    init(name: String, description: String, link: URL, icon_url: URL, iconData: Data? = nil) {
        self.name = name
        self.description = description
        self.link = link
        self.icon_url = icon_url
        self.iconData = iconData
    }
}

