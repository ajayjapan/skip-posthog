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

/// Skip interface to PostHog.
///
/// - See: [https://posthog.com/docs/libraries/ios](https://posthog.com/docs/libraries/ios)
/// - See: [https://posthog.com/docs/libraries/android](https://posthog.com/docs/libraries/android)
public class SkipPostHog {
    public static let shared = SkipPostHog()

    init() {
    }

    public func setup(apiKey: String, host: String) {
        #if SKIP
        PostHogAndroid.setup(ProcessInfo.processInfo.androidContext, PostHogAndroidConfig(apiKey: apiKey, host: host))
        #else
        PostHogSDK.shared.setup(PostHogConfig(apiKey: apiKey, host: host))
        #endif
    }

    public func capture(_ event: String, distinctId: String? = nil, properties: [String: Any]? = nil, userProperties: [String: Any]? = nil, userPropertiesSetOnce: [String: Any]? = nil, groups: [String: String]? = nil, timestamp: Date? = nil) {
        #if SKIP
        PostHog.capture(event: event, distinctId: distinctId, properties: convertAnyMap(properties), userProperties: convertAnyMap(userProperties), userPropertiesSetOnce: convertAnyMap(userPropertiesSetOnce), groups: convertStringMap(groups), timestamp: timestamp?.kotlin())
        #else
        PostHogSDK.shared.capture(event, distinctId: distinctId, properties: properties, userProperties: userProperties, userPropertiesSetOnce: userPropertiesSetOnce, groups: groups, timestamp: timestamp)
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
#endif

