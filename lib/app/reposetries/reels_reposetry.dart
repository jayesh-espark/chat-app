import 'package:chating_app/app/api/api_call_methods.dart';
import '../model/reels_model.dart';

class ReelRepository {
  ReelRepository._internal();
  static final ReelRepository _instance = ReelRepository._internal();
  factory ReelRepository() => _instance;

  Future<List<ReelsModel>> getReels({int page = 1, int limit = 10}) async {
    try {
      final response = await ApiService.request(
        endpoint: "reels",
        queryParams: {"page": page.toString(), "limit": limit.toString()},
      );
      final List<dynamic> data = response as List;
      return data.map((e) => ReelsModel.fromJson(e)).toList();
    } catch (e) {
      print('❌ Failed to fetch reels: $e');
      return [];
    }
  }
}
