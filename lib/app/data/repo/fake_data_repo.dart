import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class FakeDataRepository {
  final dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

  Future<Response> getFakeTitleBodyData() async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/posts');
    return response;
  }
}
