//
//  ForceUpdateService.swift
//  ibvn
//

import Foundation
import FirebaseRemoteConfig

@MainActor
final class ForceUpdateService: ObservableObject {
    static let shared = ForceUpdateService()

    @Published var isUpdateRequired: Bool = false
    @Published var storeUrl: URL?

    private let minVersionKey = "minimum_required_version"
    private let storeUrlKey = "app_store_url"

    private init() {}

    func check() async {
        let config = RemoteConfig.remoteConfig()

        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        config.configSettings = settings

        config.setDefaults([
            minVersionKey: "1.0" as NSString,
            storeUrlKey: "https://apps.apple.com/app/id0000000000" as NSString
        ])

        do {
            _ = try await config.fetchAndActivate()
        } catch {
            return
        }

        let minRequired = config.configValue(forKey: minVersionKey).stringValue ?? "1.0"
        let urlString = config.configValue(forKey: storeUrlKey).stringValue ?? ""

        storeUrl = URL(string: urlString)

        let current = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0"
        isUpdateRequired = current.compare(minRequired, options: .numeric) == .orderedAscending
    }
}
