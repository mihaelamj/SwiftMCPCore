import Foundation

// MARK: - MCP Protocol Method Names

/// MCP protocol method identifiers
public extension MCP.Core.Protocols {
    enum Method {
        // MARK: Initialization

        /// Initialize connection method
        public static let initialize = "initialize"

        // MARK: Resources

        /// List all resources
        public static let resourcesList = "resources/list"

        /// Read a specific resource
        public static let resourcesRead = "resources/read"

        /// List resource templates
        public static let resourcesTemplatesList = "resources/templates/list"

        /// Subscribe to resource updates
        public static let resourcesSubscribe = "resources/subscribe"

        /// Unsubscribe from resource updates
        public static let resourcesUnsubscribe = "resources/unsubscribe"

        // MARK: Tools

        /// List all tools
        public static let toolsList = "tools/list"

        /// Call a tool
        public static let toolsCall = "tools/call"

        // MARK: Prompts

        /// List all prompts
        public static let promptsList = "prompts/list"

        /// Get a specific prompt
        public static let promptsGet = "prompts/get"

        // MARK: Notifications

        /// Client to server: initialization complete. Sent by the client after it
        /// receives the `initialize` result, per the MCP 2025-11-25 lifecycle. A
        /// spec-compliant server blocks request dispatch until it arrives.
        public static let notificationsInitialized = "notifications/initialized"

        /// Resource updated notification
        public static let notificationsResourcesUpdated = "notifications/resources/updated"

        /// Resource list changed notification
        public static let notificationsResourcesListChanged = "notifications/resources/list_changed"

        /// Tool list changed notification
        public static let notificationsToolsListChanged = "notifications/tools/list_changed"

        /// Prompt list changed notification
        public static let notificationsPromptsListChanged = "notifications/prompts/list_changed"
    }
}
