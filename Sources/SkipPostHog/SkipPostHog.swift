// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation

#if SKIP
import com.posthog.PostHog
import com.posthog.android.PostHogAndroid
import com.posthog.android.PostHogAndroidConfig
#else
import PostHog
#endif

/// Skip interface to PostHog, which matches the API surface of the PostHog iOS SDK.
///
/// - See: [https://posthog.com/docs/libraries/ios](https://posthog.com/docs/libraries/ios)
/// - See: [https://posthog.com/docs/libraries/android](https://posthog.com/docs/libraries/android)
public class PostHogSDK {
    public static let shared = PostHogSDK()

    init() {
    }

    public func setup(_ config: PostHogConfig) {
        #if !SKIP
        PostHog.PostHogSDK.shared.setup(config.platformValue)
        #else
        PostHogAndroid.setup(ProcessInfo.processInfo.androidContext, config.platformValue)
        #endif
    }

    public func close() {
        #if !SKIP
        PostHog.PostHogSDK.shared.close()
        #else
        PostHog.close()
        #endif
    }

    public func flush() {
        #if !SKIP
        PostHog.PostHogSDK.shared.flush()
        #else
        PostHog.flush()
        #endif
    }

    public func getDistinctId() -> String {
        #if !SKIP
        PostHog.PostHogSDK.shared.getDistinctId()
        #else
        PostHog.distinctId()
        #endif
    }

//    public func getAnonymousId() -> String {
//        #if !SKIP
//        PostHog.PostHogSDK.shared.getAnonymousId()
//        #else
//        PostHog.anonymousId() // “Unresolved reference 'anonymousId'.” ?
//        #endif
//    }

    public func getSessionId() -> String? {
        #if !SKIP
        PostHog.PostHogSDK.shared.getSessionId()
        #else
        PostHog.getSessionId()?.toString() // UUID
        #endif
    }

    public func startSession() {
        #if !SKIP
        PostHog.PostHogSDK.shared.startSession()
        #else
        PostHog.startSession()
        #endif
    }

    public func endSession() {
        #if !SKIP
        PostHog.PostHogSDK.shared.endSession()
        #else
        PostHog.endSession()
        #endif
    }

    /// Opt users out on a per-person basis by calling optOut()
    public func optOut() {
        #if !SKIP
        PostHog.PostHogSDK.shared.optOut()
        #else
        PostHog.optOut()
        #endif
    }

    public func isOptOut() -> Bool {
        #if !SKIP
        PostHog.PostHogSDK.shared.isOptOut()
        #else
        PostHog.isOptOut()
        #endif
    }

    public func optIn() {
        #if !SKIP
        PostHog.PostHogSDK.shared.optIn()
        #else
        PostHog.optIn()
        #endif
    }

    /// To reset the user's ID and anonymous ID, call reset. Usually you would do this right after the user logs out.
    public func reset() {
        #if !SKIP
        PostHog.PostHogSDK.shared.reset()
        #else
        PostHog.reset()
        #endif
    }

    /// Sometimes, you want to assign multiple distinct IDs to a single user. This is helpful when your primary distinct ID is inaccessible. For example, if a distinct ID used on the frontend is not available in your backend. In this case, you can use alias to assign another distinct ID to the same user.
    public func alias(_ alias: String) {
        #if !SKIP
        PostHog.PostHogSDK.shared.alias(alias)
        #else
        PostHog.alias(alias)
        #endif
    }

    /// Super properties are properties associated with events that are set once and then sent with every capture call, be it a $screen, or anything else. They are set using PostHogSDK.shared.register, which takes a properties object as a parameter, and they persist across sessions.
    public func register(_ properties: [String: Any]) {
        #if !SKIP
        PostHog.PostHogSDK.shared.register(properties)
        #else
        for (key, value) in properties {
            PostHog.register(key, value)
        }
        #endif
    }

    /// Super properties persist across sessions so you have to explicitly remove them if they are no longer relevant.
    public func unregister(_ property: String) {
        #if !SKIP
        PostHog.PostHogSDK.shared.unregister(property)
        #else
        PostHog.unregister(property)
        #endif
    }

    // MARK: Feature Flags

    public func reloadFeatureFlags() {
        #if !SKIP
        PostHog.PostHogSDK.shared.reloadFeatureFlags()
        #else
        PostHog.reloadFeatureFlags()
        #endif
    }

    public func isFeatureEnabled(_ featureFlag: String) -> Bool {
        #if !SKIP
        PostHog.PostHogSDK.shared.isFeatureEnabled(featureFlag)
        #else
        PostHog.isFeatureEnabled(featureFlag)
        #endif
    }

    public func getFeatureFlag(_ featureFlag: String) -> Any? {
        #if !SKIP
        PostHog.PostHogSDK.shared.getFeatureFlag(featureFlag)
        #else
        PostHog.getFeatureFlag(featureFlag)
        #endif
    }

    public func getFeatureFlagPayload(_ featureFlag: String) -> Any? {
        #if !SKIP
        PostHog.PostHogSDK.shared.getFeatureFlagPayload(featureFlag)
        #else
        PostHog.getFeatureFlagPayload(featureFlag)
        #endif
    }

    // MARK: Group analytics

    public func group(type: String, key: String, groupProperties: [String: Any]? = nil) {
        #if !SKIP
        PostHog.PostHogSDK.shared.group(type: type, key: key, groupProperties: groupProperties)
        #else
        PostHog.group(type: type, key: key, groupProperties: convertAnyMap(groupProperties))
        #endif
    }

    /// Using identify, you can associate events with specific users. This enables you to gain full insights as to how they're using your product across different sessions, devices, and platforms.
    ///
    /// See: [https://posthog.com/docs/product-analytics/identify](https://posthog.com/docs/product-analytics/identify)
    public func identify(_ distinctId: String, userProperties: [String: Any]? = nil, userPropertiesSetOnce: [String: Any]? = nil) {
        #if !SKIP
        PostHog.PostHogSDK.shared.identify(distinctId, userProperties: userProperties, userPropertiesSetOnce: userPropertiesSetOnce)
        #else
        PostHog.identify(distinctId: distinctId, userProperties: convertAnyMap(userProperties), userPropertiesSetOnce: convertAnyMap(userPropertiesSetOnce))
        #endif
    }

    /// You can send custom events using capture.
    public func capture(_ event: String, distinctId: String? = nil, properties: [String: Any]? = nil, userProperties: [String: Any]? = nil, userPropertiesSetOnce: [String: Any]? = nil, groups: [String: String]? = nil, timestamp: Date? = nil) {
        #if !SKIP
        PostHog.PostHogSDK.shared.capture(event, distinctId: distinctId, properties: properties, userProperties: userProperties, userPropertiesSetOnce: userPropertiesSetOnce, groups: groups, timestamp: timestamp)
        #else
        PostHog.capture(event: event, distinctId: distinctId, properties: convertAnyMap(properties), userProperties: convertAnyMap(userProperties), userPropertiesSetOnce: convertAnyMap(userPropertiesSetOnce), groups: convertStringMap(groups), timestamp: timestamp?.kotlin())
        #endif
    }
  
    public func screen(_ screenTitle: String, properties: [String: Any]? = nil) {
        #if !SKIP
        PostHog.PostHogSDK.shared.screen(screenTitle, properties: properties)
        #else
        PostHog.screen(screenTitle: screenTitle, properties: convertAnyMap(properties))
        #endif
    }

    #if SKIP
    /// Converts the given typed SkipFoundation Dictionary into a Kotlin Map
    func convertAnyMap(_ map: [String: Any]?) -> Map<String, Any>? {
        guard let map else { return nil }
        var mmap: MutableMap<String, Any> = mutableMapOf()
        for (key, value) in map {
            mmap[key] = value.kotlin()
        }
        return mmap
    }

    /// Converts the given typed SkipFoundation Dictionary into a Kotlin Map
    func convertStringMap(_ map: [String: String]?) -> Map<String, String>? {
        guard let map else { return nil }
        var mmap: MutableMap<String, String> = mutableMapOf()
        for (key, value) in map {
            mmap[key] = value
        }
        return mmap
    }
    #endif
}


/// Skip interface to `PostHogConfig`, which matches the API surface of the PostHog iOS SDK.
///
/// - See: [https://posthog.com/docs/libraries/ios](https://posthog.com/docs/libraries/ios)
/// - See: [https://posthog.com/docs/libraries/android](https://posthog.com/docs/libraries/android)
public class PostHogConfig {
    #if !SKIP
    let platformValue: PostHog.PostHogConfig
    #else
    let platformValue: PostHogAndroidConfig
    #endif

    public init(apiKey: String) {
        #if !SKIP
        self.platformValue = PostHog.PostHogConfig(apiKey: apiKey)
        #else
        self.platformValue = PostHogAndroidConfig(apiKey: apiKey)
        #endif
    }

    public init(apiKey: String, host: String) {
        #if !SKIP
        self.platformValue = PostHog.PostHogConfig(apiKey: apiKey, host: host)
        #else
        self.platformValue = PostHogAndroidConfig(apiKey: apiKey, host: host)
        #endif
    }

    public var host: URL {
        #if !SKIP
        self.platformValue.host
        #else
        URL(string: (self.platformValue.host.hasPrefix("http") ? "" : "https://") + self.platformValue.host)!
        #endif
    }

    public var apiKey: String {
        self.platformValue.apiKey
    }

    public var flushAt: Int {
        get {
            #if !SKIP
            self.platformValue.flushAt
            #else
            self.platformValue.flushAt
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.flushAt = newValue
            #else
            self.platformValue.flushAt = newValue
            #endif
        }
    }

    public var maxQueueSize: Int {
        get {
            #if !SKIP
            self.platformValue.maxQueueSize
            #else
            self.platformValue.maxQueueSize
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.maxQueueSize = newValue
            #else
            self.platformValue.maxQueueSize = newValue
            #endif
        }
    }

    public var maxBatchSize: Int {
        get {
            #if !SKIP
            self.platformValue.maxBatchSize
            #else
            self.platformValue.maxBatchSize
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.maxBatchSize = newValue
            #else
            self.platformValue.maxBatchSize = newValue
            #endif
        }
    }

    public var flushIntervalSeconds: TimeInterval {
        get {
            #if !SKIP
            self.platformValue.flushIntervalSeconds
            #else
            TimeInterval(self.platformValue.flushIntervalSeconds) // Int on Android
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.flushIntervalSeconds = newValue
            #else
            self.platformValue.flushIntervalSeconds = Int(newValue) // Int on Android
            #endif
        }
    }

    public var sendFeatureFlagEvent: Bool {
        get {
            #if !SKIP
            self.platformValue.sendFeatureFlagEvent
            #else
            self.platformValue.sendFeatureFlagEvent
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.sendFeatureFlagEvent = newValue
            #else
            self.platformValue.sendFeatureFlagEvent = newValue
            #endif
        }
    }

    public var preloadFeatureFlags: Bool {
        get {
            #if !SKIP
            self.platformValue.preloadFeatureFlags
            #else
            self.platformValue.preloadFeatureFlags
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.preloadFeatureFlags = newValue
            #else
            self.platformValue.preloadFeatureFlags = newValue
            #endif
        }
    }

    public var remoteConfig: Bool {
        get {
            #if !SKIP
            self.platformValue.remoteConfig
            #else
            self.platformValue.remoteConfig
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.remoteConfig = newValue
            #else
            self.platformValue.remoteConfig = newValue
            #endif
        }
    }

    public var captureApplicationLifecycleEvents: Bool {
        get {
            #if !SKIP
            self.platformValue.captureApplicationLifecycleEvents
            #else
            self.platformValue.captureApplicationLifecycleEvents
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.captureApplicationLifecycleEvents = newValue
            #else
            self.platformValue.captureApplicationLifecycleEvents = newValue
            #endif
        }
    }

    public var captureScreenViews: Bool {
        get {
            #if !SKIP
            self.platformValue.captureScreenViews
            #else
            self.platformValue.captureScreenViews
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.captureScreenViews = newValue
            #else
            self.platformValue.captureScreenViews = newValue
            #endif
        }
    }

    public var enableSwizzling: Bool {
        get {
            #if !SKIP
            self.platformValue.enableSwizzling
            #else
            false
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.enableSwizzling = newValue
            #else
            // no-op: Android doesn't support swizzling
            #endif
        }
    }

//    public var captureElementInteractions: Bool {
//        get {
//            #if !SKIP
//            self.platformValue.captureElementInteractions
//            #else
//            self.platformValue.captureElementInteractions
//            #endif
//        }
//
//        set {
//            #if !SKIP
//            self.platformValue.captureElementInteractions = newValue
//            #else
//            self.platformValue.captureElementInteractions = newValue
//            #endif
//        }
//    }

    public var debug: Bool {
        get {
            #if !SKIP
            self.platformValue.debug
            #else
            self.platformValue.debug
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.debug = newValue
            #else
            self.platformValue.debug = newValue
            #endif
        }
    }

    public var optOut: Bool {
        get {
            #if !SKIP
            self.platformValue.optOut
            #else
            self.platformValue.optOut
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.optOut = newValue
            #else
            self.platformValue.optOut = newValue
            #endif
        }
    }

    public var reuseAnonymousId: Bool {
        get {
            #if !SKIP
            self.platformValue.reuseAnonymousId
            #else
            self.platformValue.reuseAnonymousId
            #endif
        }

        set {
            #if !SKIP
            self.platformValue.reuseAnonymousId = newValue
            #else
            self.platformValue.reuseAnonymousId = newValue
            #endif
        }
    }

}

#if SKIP
extension PostHogConfig: KotlinConverting<PostHogAndroidConfig> {
    // SKIP @nobridge
    public override func kotlin(nocopy: Bool = false) -> PostHogAndroidConfig {
        return platformValue
    }
}
#endif
#endif
