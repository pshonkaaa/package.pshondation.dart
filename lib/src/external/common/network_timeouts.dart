class NetworkTimeouts {
  final Duration connection;
  final Duration response;
  final Duration receiveTotal;
  final Duration idle;
  final Duration closing;
  const NetworkTimeouts({
    this.connection = const Duration(seconds: 6),
    this.response = const Duration(seconds: 10),
    this.receiveTotal = const Duration(minutes: 2),
    this.idle = const Duration(seconds: 10),
    this.closing = const Duration(seconds: 5),
  });

  NetworkTimeouts copyWith({
    Duration? connection,
    Duration? response,
    Duration? receiveTotal,
    Duration? idle,
    Duration? closing,
  }) => NetworkTimeouts(
    connection: connection ?? this.connection,
    response: response ?? this.response,
    receiveTotal: receiveTotal ?? this.receiveTotal,
    idle: idle ?? this.idle,
    closing: closing ?? this.closing,
  );
}