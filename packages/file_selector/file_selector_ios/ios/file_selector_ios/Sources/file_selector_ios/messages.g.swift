// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v25.5.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

/// Error class for passing custom error details to Dart side.
final class PigeonError: Error {
  let code: String
  let message: String?
  let details: Sendable?

  init(code: String, message: String?, details: Sendable?) {
    self.code = code
    self.message = message
    self.details = details
  }

  var localizedDescription: String {
    return
      "PigeonError(code: \(code), message: \(message ?? "<nil>"), details: \(details ?? "<nil>")"
  }
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let pigeonError = error as? PigeonError {
    return [
      pigeonError.code,
      pigeonError.message,
      pigeonError.details,
    ]
  }
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details,
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)",
  ]
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

func deepEqualsmessages(_ lhs: Any?, _ rhs: Any?) -> Bool {
  let cleanLhs = nilOrValue(lhs) as Any?
  let cleanRhs = nilOrValue(rhs) as Any?
  switch (cleanLhs, cleanRhs) {
  case (nil, nil):
    return true

  case (nil, _), (_, nil):
    return false

  case is (Void, Void):
    return true

  case let (cleanLhsHashable, cleanRhsHashable) as (AnyHashable, AnyHashable):
    return cleanLhsHashable == cleanRhsHashable

  case let (cleanLhsArray, cleanRhsArray) as ([Any?], [Any?]):
    guard cleanLhsArray.count == cleanRhsArray.count else { return false }
    for (index, element) in cleanLhsArray.enumerated() {
      if !deepEqualsmessages(element, cleanRhsArray[index]) {
        return false
      }
    }
    return true

  case let (cleanLhsDictionary, cleanRhsDictionary) as ([AnyHashable: Any?], [AnyHashable: Any?]):
    guard cleanLhsDictionary.count == cleanRhsDictionary.count else { return false }
    for (key, cleanLhsValue) in cleanLhsDictionary {
      guard cleanRhsDictionary.index(forKey: key) != nil else { return false }
      if !deepEqualsmessages(cleanLhsValue, cleanRhsDictionary[key]!) {
        return false
      }
    }
    return true

  default:
    // Any other type shouldn't be able to be used with pigeon. File an issue if you find this to be untrue.
    return false
  }
}

func deepHashmessages(value: Any?, hasher: inout Hasher) {
  if let valueList = value as? [AnyHashable] {
    for item in valueList { deepHashmessages(value: item, hasher: &hasher) }
    return
  }

  if let valueDict = value as? [AnyHashable: AnyHashable] {
    for key in valueDict.keys {
      hasher.combine(key)
      deepHashmessages(value: valueDict[key]!, hasher: &hasher)
    }
    return
  }

  if let hashableValue = value as? AnyHashable {
    hasher.combine(hashableValue.hashValue)
  }

  return hasher.combine(String(describing: value))
}

/// Generated class from Pigeon that represents data sent in messages.
struct FileSelectorConfig: Hashable {
  var utis: [String]
  var allowMultiSelection: Bool

  // swift-format-ignore: AlwaysUseLowerCamelCase
  static func fromList(_ pigeonVar_list: [Any?]) -> FileSelectorConfig? {
    let utis = pigeonVar_list[0] as! [String]
    let allowMultiSelection = pigeonVar_list[1] as! Bool

    return FileSelectorConfig(
      utis: utis,
      allowMultiSelection: allowMultiSelection
    )
  }
  func toList() -> [Any?] {
    return [
      utis,
      allowMultiSelection,
    ]
  }
  static func == (lhs: FileSelectorConfig, rhs: FileSelectorConfig) -> Bool {
    return deepEqualsmessages(lhs.toList(), rhs.toList())
  }
  func hash(into hasher: inout Hasher) {
    deepHashmessages(value: toList(), hasher: &hasher)
  }
}

private class MessagesPigeonCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
    case 129:
      return FileSelectorConfig.fromList(self.readValue() as! [Any?])
    default:
      return super.readValue(ofType: type)
    }
  }
}

private class MessagesPigeonCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? FileSelectorConfig {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class MessagesPigeonCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return MessagesPigeonCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return MessagesPigeonCodecWriter(data: data)
  }
}

class MessagesPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
  static let shared = MessagesPigeonCodec(readerWriter: MessagesPigeonCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol FileSelectorApi {
  func openFile(config: FileSelectorConfig, completion: @escaping (Result<[String], Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class FileSelectorApiSetup {
  static var codec: FlutterStandardMessageCodec { MessagesPigeonCodec.shared }
  /// Sets up an instance of `FileSelectorApi` to handle messages through the `binaryMessenger`.
  static func setUp(
    binaryMessenger: FlutterBinaryMessenger, api: FileSelectorApi?,
    messageChannelSuffix: String = ""
  ) {
    let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    let openFileChannel = FlutterBasicMessageChannel(
      name: "dev.flutter.pigeon.file_selector_ios.FileSelectorApi.openFile\(channelSuffix)",
      binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      openFileChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let configArg = args[0] as! FileSelectorConfig
        api.openFile(config: configArg) { result in
          switch result {
          case .success(let res):
            reply(wrapResult(res))
          case .failure(let error):
            reply(wrapError(error))
          }
        }
      }
    } else {
      openFileChannel.setMessageHandler(nil)
    }
  }
}
