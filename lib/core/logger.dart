import 'package:logger/logger.dart';

/// Custom logger. It use for update ui for basic log
///
/// Version 0.0.1
Logger logger = Logger(
  printer: PrettyPrinter(
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    printTime: false,
  ),
);
