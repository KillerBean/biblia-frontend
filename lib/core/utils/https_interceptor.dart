import 'package:dio/dio.dart';

/// Rejects any non-HTTPS request in release builds.
/// Allows HTTP only in debug (for localhost dev server).
class HttpsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!options.uri.isScheme('https') && !options.uri.isScheme('http')) {
      handler.reject(DioException(
        requestOptions: options,
        message: 'Esquema de URL inválido: ${options.uri.scheme}',
        type: DioExceptionType.cancel,
      ));
      return;
    }

    // In release, block plain HTTP (allow only HTTPS).
    const bool isRelease = bool.fromEnvironment('dart.vm.product');
    if (isRelease && options.uri.isScheme('http')) {
      handler.reject(DioException(
        requestOptions: options,
        message: 'HTTP não permitido em produção. Use HTTPS.',
        type: DioExceptionType.cancel,
      ));
      return;
    }

    super.onRequest(options, handler);
  }
}
