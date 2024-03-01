import 'dart:convert';

import 'package:my24_flutter_core/api/base_crud.dart';

import 'models.dart';

class BranchApi extends BaseCrud<Branch, Branches> {
  @override
  get basePath {
    return "/company/branch";
  }

  @override
  Branch fromJsonDetail(Map<String, dynamic>? parsedJson) {
    return Branch.fromJson(parsedJson!);
  }

  @override
  Branches fromJsonList(Map<String, dynamic>? parsedJson) {
    return Branches.fromJson(parsedJson!);
  }

  Future <List<BranchTypeAheadModel>> typeAhead(String query) async {
    final String responseBody = await getListResponseBody(filters: {'q': query}, basePathAddition: 'autocomplete');
    var parsedJson = json.decode(responseBody);
    var list = parsedJson as List;
    List<BranchTypeAheadModel> results = list.map((i) => BranchTypeAheadModel.fromJson(i)).toList();

    return results;
  }
}

class MyBranchApi extends BaseCrud<Branch, Branches> {
  @override
  get basePath {
    return "/company/branch-my";
  }

  @override
  Branch fromJsonDetail(Map<String, dynamic>? parsedJson) {
    return Branch.fromJson(parsedJson!);
  }

  @override
  Branches fromJsonList(Map<String, dynamic>? parsedJson) {
    return Branches.fromJson(parsedJson!);
  }

  Future<Branch> fetchMyBranch() async {
    return await detail(null);
  }
}
