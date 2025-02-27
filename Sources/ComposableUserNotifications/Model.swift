import UserNotifications
import CoreLocation
import XCTestDynamicOverlay

public struct Notification: Equatable {
  public let rawValue: UNNotification?

  public var date: Date
  public var request: Request

  public init(rawValue: UNNotification) {
    self.rawValue = rawValue

    self.date = rawValue.date
    self.request = Request(rawValue: rawValue.request)
  }

  public init(date: Date, request: Request) {
    self.rawValue = nil

    self.date = date
    self.request = request
  }

  public static func == (lhs: Notification, rhs: Notification) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

extension Notification {
  public struct Request: Equatable {
    public let rawValue: UNNotificationRequest?

    public var identifier: String
    public var content: Content
    public var trigger: Trigger?

    public init(rawValue: UNNotificationRequest) {
      self.rawValue = rawValue

      self.identifier = rawValue.identifier
      self.content = Content(rawValue: rawValue.content)

      self.trigger = {
        switch rawValue.trigger {
        case let trigger as UNPushNotificationTrigger:
          return .push(Trigger.Push(rawValue: trigger))
        case let trigger as UNCalendarNotificationTrigger:
          return .calendar(Trigger.Calendar(rawValue: trigger))
        case let trigger as UNTimeIntervalNotificationTrigger:
          return .timeInterval(Trigger.TimeInterval(rawValue: trigger))
        #if os(iOS) || os(watchOS)
        case let trigger as UNLocationNotificationTrigger:
          return .location(Trigger.Location(rawValue: trigger))
        #endif
        default:
          return nil
        }
      }()
    }

    public init(identifier: String, content: Content, trigger: Trigger?) {
      self.rawValue = nil

      self.identifier = identifier
      self.content = content
      self.trigger = trigger
    }

    public static func == (lhs: Request, rhs: Request) -> Bool {
      lhs.rawValue == rhs.rawValue
    }
  }
}

extension Notification {
  public struct Content: Equatable {
    public var rawValue: UNNotificationContent?

    @available(tvOS, unavailable)
    public var title: String { getTitle() }
    private var getTitle: () -> String = unimplemented("title")
    
    @available(tvOS, unavailable)
    public var subtitle: String { getSubtitle() }
    private var getSubtitle: () -> String = unimplemented("subtitle")

    @available(tvOS, unavailable)
    public var body: String { getBody() }
    private var getBody: () -> String = unimplemented("body")

    public var badge: () -> NSNumber? = unimplemented("badge")

    @available(tvOS, unavailable)
    public var sound: UNNotificationSound? { getSound() }
    private var getSound: () -> UNNotificationSound? = unimplemented("sound")

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    public var launchImageName: String { getLaunchImageName() }
    private var getLaunchImageName: () -> String = unimplemented("launchImageName")

    @available(tvOS, unavailable)
    public var userInfo: [AnyHashable: Any] { getUserInfo() }
    private var getUserInfo: () -> [AnyHashable: Any] = unimplemented("userInfo")

    @available(tvOS, unavailable)
    public var attachments: [Notification.Attachment] { getAttachments() }
    private var getAttachments: () -> [Notification.Attachment] = unimplemented("attachments")

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var summaryArgument: String { getSummaryArgument() }
    private var getSummaryArgument: () -> String = unimplemented("summaryArgument")

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var summaryArgumentCount: Int { getSummaryArgumentCount() }
    private var getSummaryArgumentCount: () -> Int = unimplemented("summaryArgumentCount")

    @available(tvOS, unavailable)
    public var categoryIdentifier: String { getCategoryIdentifier() }
    private var getCategoryIdentifier: () -> String = unimplemented("categoryIdentifier")

    @available(tvOS, unavailable)
    public var threadIdentifier: String { getThreadIdentifier() }
    private var getThreadIdentifier: () -> String = unimplemented("threadIdentifier")

    public var targetContentIdentifier: () -> String? = unimplemented("targetContentIdentifier")

    public init(rawValue: UNNotificationContent) {
      self.rawValue = rawValue

      #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getTitle = { rawValue.title }
      #endif

      #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getSubtitle = { rawValue.subtitle }
      #endif

      #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getBody = { rawValue.body }
      #endif

      self.badge = { rawValue.badge }

      #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getSound = { rawValue.sound }
      #endif

      #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getLaunchImageName = { rawValue.launchImageName }
      #endif

      #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getUserInfo = { rawValue.userInfo }
      #endif

      #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getAttachments = { rawValue.attachments.map(Notification.Attachment.init) }
      #endif

      #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
      self.getSummaryArgument = { rawValue.summaryArgument }
      #endif

      #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
      self.getSummaryArgumentCount = { rawValue.summaryArgumentCount }
      #endif

      #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getCategoryIdentifier = { rawValue.categoryIdentifier }
      #endif

      #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getThreadIdentifier = { rawValue.threadIdentifier }
      #endif

      self.targetContentIdentifier = { rawValue.targetContentIdentifier }
    }

    public static func == (lhs: Content, rhs: Content) -> Bool {
      lhs.rawValue == rhs.rawValue
    }
  }
}

extension Notification {
  @available(tvOS, unavailable)
  public struct Attachment {
    public let rawValue: UNNotificationAttachment?

    public var identifier: String
    public var url: URL
    public var type: String

    public init(rawValue: UNNotificationAttachment) {
      self.rawValue = rawValue

      self.identifier = rawValue.identifier
      self.url = rawValue.url
      self.type = rawValue.type
    }

    public init(identifier: String, url: URL, type: String) {
      self.rawValue = nil

      self.identifier = identifier
      self.url = url
      self.type = type
    }

    public static func == (lhs: Attachment, rhs: Attachment) -> Bool {
      lhs.rawValue == rhs.rawValue
    }
  }
}

extension Notification {
  public enum Trigger: Equatable {
    case push(Push)
    case timeInterval(TimeInterval)
    case calendar(Calendar)

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    case location(Location)

    public static func == (lhs: Trigger, rhs: Trigger) -> Bool {
      switch (lhs, rhs) {
      case let (.push(lhs), .push(rhs)):
        return lhs == rhs
      case let (.timeInterval(lhs), .timeInterval(rhs)):
        return lhs == rhs
      case let (.calendar(lhs), .calendar(rhs)):
        return lhs == rhs
      #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
      case let (.location(lhs), .location(rhs)):
        return lhs == rhs
      #endif
      default:
        return false
      }
    }
  }
}

extension Notification.Trigger {
  public var repeats: Bool {
    switch self {
    case let .push(value):
      return value.repeats
    case let .timeInterval(value):
      return value.repeats
    case let .calendar(value):
      return value.repeats
    #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
    case let .location(value):
      return value.repeats
    #endif
    }
  }

  public struct Push: Equatable {
    public var rawValue: UNPushNotificationTrigger?

    public var repeats: Bool

    public init(rawValue: UNPushNotificationTrigger) {
      self.repeats = rawValue.repeats
    }

    public init(repeats: Bool) {
      self.repeats = repeats
    }

    public static func == (lhs: Push, rhs: Push) -> Bool {
      lhs.rawValue == rhs.rawValue
    }
  }

  public struct TimeInterval: Equatable {
    public let rawValue: UNTimeIntervalNotificationTrigger?

    public var repeats: Bool
    public var timeInterval: Foundation.TimeInterval
    public var nextTriggerDate: () -> Date?

    init(rawValue: UNTimeIntervalNotificationTrigger) {
      self.rawValue = rawValue

      self.repeats = rawValue.repeats
      self.timeInterval = rawValue.timeInterval
      self.nextTriggerDate = rawValue.nextTriggerDate
    }

    public init(repeats: Bool, timeInterval: Foundation.TimeInterval, nextTriggerDate: @escaping () -> Date?) {
      self.rawValue = nil

      self.repeats = repeats
      self.timeInterval = timeInterval
      self.nextTriggerDate = nextTriggerDate
    }

    public static func == (lhs: TimeInterval, rhs: TimeInterval) -> Bool {
      lhs.rawValue == rhs.rawValue
    }
  }

  public struct Calendar: Equatable {
    public let rawValue: UNCalendarNotificationTrigger?

    public var repeats: Bool
    public var dateComponents: DateComponents
    public var nextTriggerDate: () -> Date?

    public init(rawValue: UNCalendarNotificationTrigger) {
      self.rawValue = rawValue

      self.repeats = rawValue.repeats
      self.dateComponents = rawValue.dateComponents
      self.nextTriggerDate = rawValue.nextTriggerDate
    }

    public init(repeats: Bool, dateComponents: DateComponents, nextTriggerDate: @escaping () -> Date?) {
      self.rawValue = nil

      self.repeats = repeats
      self.dateComponents = dateComponents
      self.nextTriggerDate = nextTriggerDate
    }

    public static func == (lhs: Calendar, rhs: Calendar) -> Bool {
      lhs.rawValue == rhs.rawValue
    }
  }

  @available(macOS, unavailable)
  @available(tvOS, unavailable)
  public struct Location: Equatable {
    public let rawValue: UNLocationNotificationTrigger?

    public var repeats: Bool
    public var region: Region

    public init(rawValue: UNLocationNotificationTrigger) {
      self.rawValue = rawValue

      self.repeats = rawValue.repeats
      self.region = Region(rawValue: rawValue.region)
    }

    public init(repeats: Bool, region: Region) {
      self.rawValue = nil

      self.repeats = repeats
      self.region = region
    }
  }
}

extension Notification {
  @available(tvOS, unavailable)
  public enum Response: Equatable {
    case user(UserAction)
    case textInput(TextInputAction)
  }
}

@available(tvOS, unavailable)
extension Notification.Response {
  public var actionIdentifier: String {
    switch self {
    case let .user(value):
      return value.actionIdentifier
    case let .textInput(value):
      return value.actionIdentifier
    }
  }

  public var notification: Notification {
    switch self {
    case let .user(value):
      return value.notification
    case let .textInput(value):
      return value.notification
    }
  }
}

@available(tvOS, unavailable)
extension Notification.Response {
  public init(rawValue: UNNotificationResponse) {
    switch rawValue {
    case let rawValue as UNTextInputNotificationResponse:
      self = .textInput(Notification.Response.TextInputAction(rawValue: rawValue))
    default:
      self = .user(Notification.Response.UserAction(rawValue: rawValue))
    }
  }

  public struct UserAction: Equatable {
    public let rawValue: UNNotificationResponse?

    public var actionIdentifier: String
    public var notification: Notification

    public init(rawValue: UNNotificationResponse) {
      self.rawValue = rawValue
      self.actionIdentifier = rawValue.actionIdentifier
      self.notification = Notification(rawValue: rawValue.notification)
    }

    public init(actionIdentifier: String, notification: Notification) {
      self.rawValue = nil

      self.actionIdentifier = actionIdentifier
      self.notification = notification
    }
  }

  public struct TextInputAction: Equatable {
    public let rawValue: UNTextInputNotificationResponse?

    public var actionIdentifier: String
    public var notification: Notification
    public var userText: String

    @available(tvOS, unavailable)
    public init(rawValue: UNTextInputNotificationResponse) {
      self.rawValue = rawValue
      self.actionIdentifier = rawValue.actionIdentifier
      self.notification = Notification(rawValue: rawValue.notification)
      self.userText = rawValue.userText
    }

    public init(actionIdentifier: String, notification: Notification, userText: String) {
      self.rawValue = nil

      self.actionIdentifier = actionIdentifier
      self.notification = notification
      self.userText = userText
    }
  }
}

extension Notification {
  public struct Settings: Equatable {
    public var rawValue: () -> UNNotificationSettings? = unimplemented("rawValue")

    @available(tvOS, unavailable)
    public var alertSetting: UNNotificationSetting { getAlertSetting() }
    private var getAlertSetting: () -> UNNotificationSetting = unimplemented("alertSetting")

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var alertStyle: UNAlertStyle { getAlertStyle() }
    public var getAlertStyle: () -> UNAlertStyle = unimplemented("alertStyle")

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    public var announcementSetting: UNNotificationSetting { getAnnouncementSetting() }
    private var getAnnouncementSetting: () -> UNNotificationSetting = unimplemented(
      "announcementSetting"
    )

    public var authorizationStatus: () -> UNAuthorizationStatus = unimplemented(
      "authorizationStatus"
    )

    @available(watchOS, unavailable)
    public var badgeSetting: UNNotificationSetting { getBadgeSetting() }
    private var getBadgeSetting: () -> UNNotificationSetting = unimplemented("badgeSetting")

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var carPlaySetting: UNNotificationSetting { getCarPlaySetting() }
    private var getCarPlaySetting: () -> UNNotificationSetting = unimplemented("carPlaySetting")

    @available(tvOS, unavailable)
    public var criticalAlertSetting: UNNotificationSetting { getCriticalAlertSetting() }
    private var getCriticalAlertSetting: () -> UNNotificationSetting = unimplemented(
      "criticalAlertSetting"
    )

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var lockScreenSetting: UNNotificationSetting { getLockScreenSetting() }
    private var getLockScreenSetting: () -> UNNotificationSetting = unimplemented("lockScreenSetting")

    @available(tvOS, unavailable)
    public var notificationCenterSetting: UNNotificationSetting { getNotificationCenterSetting() }
    private var getNotificationCenterSetting: () -> UNNotificationSetting = unimplemented(
      "notificationCenterSetting"
    )

    @available(tvOS, unavailable)
    public var providesAppNotificationSettings: Bool { getProvidesAppNotificationSettings() }
    private var getProvidesAppNotificationSettings: () -> Bool = unimplemented(
      "providesAppNotificationSettings"
    )

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var showPreviewsSetting: UNShowPreviewsSetting { getShowPreviewsSetting() }
    private var getShowPreviewsSetting: () -> UNShowPreviewsSetting = unimplemented(
      "showPreviewsSetting"
    )

    @available(tvOS, unavailable)
    public var soundSetting: UNNotificationSetting { getSoundSetting() }
    private var getSoundSetting: () -> UNNotificationSetting = unimplemented("soundSetting")

    public init(rawValue: UNNotificationSettings) {
      self.rawValue = { rawValue }

      #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getAlertSetting = { rawValue.alertSetting }
      #endif

      #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
      self.getAlertStyle = { rawValue.alertStyle }
      #endif

      #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getAnnouncementSetting = { rawValue.announcementSetting }
      #endif

      self.authorizationStatus = { rawValue.authorizationStatus }

      #if os(iOS) || os(macOS) || os(tvOS) || targetEnvironment(macCatalyst)
      self.getBadgeSetting = { rawValue.badgeSetting }
      #endif

      #if os(iOS) || targetEnvironment(macCatalyst)
      self.getCarPlaySetting = { rawValue.carPlaySetting }
      #endif

      #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getCriticalAlertSetting = { rawValue.criticalAlertSetting }
      #endif

      #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
      self.getLockScreenSetting = { rawValue.lockScreenSetting }
      #endif

      #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getNotificationCenterSetting = { rawValue.notificationCenterSetting }
      self.getProvidesAppNotificationSettings = {  rawValue.providesAppNotificationSettings }
      #endif

      #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
      self.getShowPreviewsSetting = { rawValue.showPreviewsSetting }
      #endif

      #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
      self.getSoundSetting = { rawValue.soundSetting }
      #endif
    }

    public static func == (lhs: Notification.Settings, rhs: Notification.Settings) -> Bool {
      lhs.rawValue() == rhs.rawValue()
    }
  }
}

// see https://github.com/pointfreeco/swift-composable-architecture/blob/767e1d9553fcee5a95af10e0352f20fb03b98352/Sources/ComposableCoreLocation/Models/Region.swift#L5
public struct Region: Hashable {
  public let rawValue: CLRegion?
  public var identifier: String
  public var notifyOnEntry: Bool
  public var notifyOnExit: Bool

  init(rawValue: CLRegion) {
    self.rawValue = rawValue
    self.identifier = rawValue.identifier
    self.notifyOnEntry = rawValue.notifyOnEntry
    self.notifyOnExit = rawValue.notifyOnExit
  }

  init(
    identifier: String,
    notifyOnEntry: Bool,
    notifyOnExit: Bool
  ) {
    self.rawValue = nil
    self.identifier = identifier
    self.notifyOnEntry = notifyOnEntry
    self.notifyOnExit = notifyOnExit
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.identifier == rhs.identifier
      && lhs.notifyOnEntry == rhs.notifyOnEntry
      && lhs.notifyOnExit == rhs.notifyOnExit
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.identifier)
    hasher.combine(self.notifyOnExit)
    hasher.combine(self.notifyOnEntry)
  }
}
