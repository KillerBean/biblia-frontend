import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Structured logger. Use this instead of print().
///
/// Rules:
/// - Never log API response bodies (may contain PII or sensitive data).
/// - In release builds, only WARNING and above are emitted.
/// - In debug builds, all levels are emitted to console.
final appLogger = Logger(
  level: kReleaseMode ? Level.warning : Level.debug,
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    printEmojis: false,
    dateTimeFormat: DateTimeFormat.none,
  ),
  output: kReleaseMode ? null : ConsoleOutput(),
);
