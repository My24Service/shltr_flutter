import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

import 'package:my24_flutter_core/api/api_mixin.dart';
import 'package:my24_flutter_core/models/models.dart';
import 'package:my24_flutter_core/utils.dart';

import '../models/models.dart';

class CompanyApi with CoreApiMixin {
  // default and settable for tests
  http.Client _httpClient = http.Client();

  set httpClient(http.Client client) {
    _httpClient = client;
  }

  Future<Branch> fetchMyBranch() async {
    SlidingToken? newToken = await refreshSlidingToken(_httpClient);

    if (newToken == null) {
      throw Exception('generic.token_expired'.tr());
    }

    final url = await getUrl('/company/branch-my/');
    final response = await _httpClient.get(
        Uri.parse(url),
        headers: coreUtils.getHeaders(newToken.token)
    );

    if (response.statusCode == 200) {
      return Branch.fromJson(json.decode(response.body));
    }

    throw Exception('generic.exception_fetch'.tr());
  }

  String? _typeAheadToken;
  Future <List<BranchTypeAheadModel>> branchTypeAhead(String query) async {
    // don't call for every search
    if (_typeAheadToken == null) {
      SlidingToken? newToken = await refreshSlidingToken(_httpClient);

      if (newToken == null) {
        throw Exception('generic.token_expired'.tr());
      }

      _typeAheadToken = newToken.token;
    }

    final url = await getUrl('/company/branch/autocomplete/?q=$query');
    final response = await _httpClient.get(
        Uri.parse(url),
        headers: getHeaders(_typeAheadToken)
    );

    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      var list = parsedJson as List;
      List<BranchTypeAheadModel> results = list.map((i) => BranchTypeAheadModel.fromJson(i)).toList();

      return results;
    }

    return [];
  }
}
