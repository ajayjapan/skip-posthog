// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation

#if SKIP
import com.posthog.android.PostHogAndroid
import com.posthog.android.PostHogAndroidConfig
#else
import PostHog
#endif

// TODO: add PostHog API
// See: https://posthog.com/docs/libraries/ios
// See: https://posthog.com/docs/libraries/android

public class SkipPostHogModule {
}
#endif

