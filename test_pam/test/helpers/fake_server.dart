import 'dart:io';
import 'dart:typed_data';

import 'package:di/di_data.dart';
import 'package:di/di_domain.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Răspunsurile reale ale serverului (salvate din GET /lab2026/v2/feed și /feed/details).
final feedJson = File('test/fixtures/feed.json').readAsStringSync();
final feedDetailsJson = File('test/fixtures/feed_details.json').readAsStringSync();

// Înlocuiește serverul: pornește DI cu un Dio care răspunde local, fără internet.
// Restul lanțului (Retrofit Service -> Repository -> UseCase -> Controller) rulează exact ca în aplicație.
// [fail] simulează o eroare de rețea, [status] un cod HTTP, [feed] alt conținut pentru /feed.
Future<void> startFakeServer({DioExceptionType? fail, int status = 200, String? feed}) async {
  await GetIt.instance.reset();
  final dio = Dio(BaseOptions(baseUrl: 'https://fake.server'))
    ..httpClientAdapter = _FakeAdapter((options) {
      if (fail != null) throw DioException(requestOptions: options, type: fail);
      final body = options.path.endsWith('/feed/details') ? feedDetailsJson : (feed ?? feedJson);
      return ResponseBody.fromString(
        body,
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    });
  injectData(dio: dio);
  injectDomain();
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  final ResponseBody Function(RequestOptions options) handler;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async =>
      handler(options);

  @override
  void close({bool force = false}) {}
}
