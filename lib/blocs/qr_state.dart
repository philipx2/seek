abstract class QRState {}

class QRInitial extends QRState {}

class QRLoading extends QRState {}

class QRSuccess extends QRState {
  final String qrText;
  QRSuccess(this.qrText);
}

class QRFailure extends QRState {
  final String error;
  QRFailure(this.error);
}

class QRHistoryLoaded extends QRState {
  final List<String> history;
  QRHistoryLoaded(this.history);
}
