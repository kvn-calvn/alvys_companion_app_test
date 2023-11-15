import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileUploadProgressNotifier extends Notifier<double> {
  @override
  double build() {
    return 0;
  }

  void updateProgress(num current, num total) {
    state = current / total;
  }
}

final fileUploadProvider = NotifierProvider<FileUploadProgressNotifier, double>(FileUploadProgressNotifier.new);
