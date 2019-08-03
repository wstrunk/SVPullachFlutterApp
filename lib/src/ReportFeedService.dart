import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class ReportFeedService {
  final _targetUrl = 'http://www.svpullach-handball.de/feed/';

  Future<RssFeed> getFeed() =>
      http.read(_targetUrl).then((xmlString) => RssFeed.parse(xmlString));
}