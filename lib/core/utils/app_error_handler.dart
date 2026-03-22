import 'package:biblia/core/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Handles errors safely:
/// - In release: returns generic user-facing messages (no URLs, no internals).
/// - In debug: returns full error detail for developer visibility.
class AppErrorHandler {
  AppErrorHandler._();

  static String toUserMessage(Object e) {
    if (kReleaseMode) {
      if (e is DioException) return _dioUserMessage(e);
      return 'Ocorreu um erro. Tente novamente.';
    }
    return e.toString();
  }

  static void log(Object e, StackTrace? st, {required String context}) {
    // Never log response data — may contain sensitive content.
    final message = e is DioException ? e.message ?? e.type.name : e.toString();
    appLogger.e(context, error: message, stackTrace: kDebugMode ? st : null);
  }

  static String _dioUserMessage(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout =>
          'Sem conexão. Verifique sua internet.',
        DioExceptionType.receiveTimeout =>
          'O servidor demorou demais. Tente novamente.',
        DioExceptionType.sendTimeout => 'Falha ao enviar dados. Tente novamente.',
        DioExceptionType.badResponse => 'Serviço indisponível.',
        DioExceptionType.cancel => 'Requisição cancelada.',
        _ => 'Erro de conexão.',
      };
}
