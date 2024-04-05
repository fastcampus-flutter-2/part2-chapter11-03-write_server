import 'package:tool_clind_network/network.dart';

class PostApi {
  final ClindRestClient _client;

  const PostApi(this._client);

  Future<dynamic> getChannels() {
    return _client.get<dynamic>('/post-api/channels').then((value) => value.data);
  }

  Future<dynamic> getPopularChannels() {
    return _client.get<dynamic>('/post-api/popular/channels').then((value) => value.data);
  }

  Future<dynamic> getPosts({
    int? take,
    int? page,
  }) {
    return _client.get<dynamic>(
      '/post-api/posts',
      queryParameters: {
        if (take != null) 'take': take,
        if (page != null) 'page': page,
      },
    ).then((value) => value.data);
  }
}
