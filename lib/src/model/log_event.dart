class LogEvent {
  final Level level;
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  LogEvent(this.level, this.message, this.error, this.stackTrace);
}

enum Level {
  verbose,
  debug,
  info,
  warning,
  error,
}
