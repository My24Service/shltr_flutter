import 'dart:convert';

import 'package:my24_flutter_core/models/base_models.dart';

class Branch extends BaseModel {
  final int? id;
  final String? name;
  final String? address;
  final String? postal;
  final String? city;
  final String? countryCode;
  final String? tel;
  final String? email;
  final String? contact;
  final String? mobile;

  Branch({
    this.id,
    this.name,
    this.address,
    this.postal,
    this.city,
    this.countryCode,
    this.tel,
    this.email,
    this.contact,
    this.mobile
  });

  factory Branch.fromJson(Map<String, dynamic> parsedJson) {
    return Branch(
      id: parsedJson['id'],
      name: parsedJson['name'],
      address: parsedJson['address'],
      postal: parsedJson['postal'],
      city: parsedJson['city'],
      countryCode: parsedJson['country_code'],
      tel: parsedJson['tel'],
      email: parsedJson['email'],
      contact: parsedJson['contact'],
      mobile: parsedJson['mobile'],
    );
  }

  @override
  String toJson() {
    Map body = {
      'id': id,
      'name': name,
      'address': address,
      'postal': postal,
      'city': city,
      'countryCode': countryCode,
      'tel': tel,
      'email': email,
      'contact': contact,
      'mobile': mobile,
    };

    return json.encode(body);
  }
}

class Branches extends BaseModelPagination {
  final int? count;
  final String? next;
  final String? previous;
  final List<Branch>? results;

  Branches({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory Branches.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;
    List<Branch> results = list.map((i) => Branch.fromJson(i)).toList();

    return Branches(
        count: parsedJson['count'],
        next: parsedJson['next'],
        previous: parsedJson['previous'],
        results: results
    );
  }
}

class BranchTypeAheadModel {
  final int? id;
  final String? name;
  final String? address;
  final String? postal;
  final String? city;
  final String? countryCode;
  final String? tel;
  final String? mobile;
  final String? email;
  final String? contact;
  final String? value;

  BranchTypeAheadModel({
    this.id,
    this.name,
    this.address,
    this.postal,
    this.city,
    this.countryCode,
    this.tel,
    this.mobile,
    this.email,
    this.contact,
    this.value,
  });

  factory BranchTypeAheadModel.fromJson(Map<String, dynamic> parsedJson) {
    return BranchTypeAheadModel(
      id: parsedJson['id'],
      name: parsedJson['name'],
      address: parsedJson['address'],
      postal: parsedJson['postal'],
      city: parsedJson['city'],
      countryCode: parsedJson['country_code'],
      tel: parsedJson['tel'],
      mobile: parsedJson['mobile'],
      email: parsedJson['email'],
      contact: parsedJson['contact'],
      value: parsedJson['value'],
    );
  }
}
