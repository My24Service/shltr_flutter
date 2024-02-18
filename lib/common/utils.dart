import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my24_flutter_core/api/api_mixin.dart';

import 'package:shltr_flutter/company/models/models.dart';
import 'package:my24_flutter_member_models/public/api.dart';
import 'package:my24_flutter_member_models/public/models.dart';

final log = Logger('Utils');

class Utils with CoreApiMixin {
  MemberDetailPublicApi memberApi = MemberDetailPublicApi();
  MemberByCompanycodePublicApi memberByCompanycodeApi = MemberByCompanycodePublicApi();

  // default and settable for tests
  http.Client _httpClient = http.Client();
  set httpClient(http.Client client) {
    _httpClient = client;
  }

  Future<int?> getEmployeeBranch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('employee_branch')) {
      var userData = await utils.getUserInfo();
      var userInfo = userData['user'];
      if (userInfo is EmployeeUser) {
        EmployeeUser employeeUser = userInfo;
        if (employeeUser.employee!.branch != null) {
          prefs.setString('submodel', 'branch_employee_user');
          prefs.setInt('employee_branch', employeeUser.employee!.branch!);
        } else {
          prefs.setString('submodel', 'employee_user');
          prefs.setInt('employee_branch', 0);
        }
      } else {
        prefs.setInt('employee_branch', 0);
      }

    }

    return prefs.getInt('employee_branch');
  }

  Future<Member?> fetchMember({String? companycode}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    companycode ??= prefs.getString('companycode');

    if (companycode == null) {
      return null;
    }

    // fetch member by company code
    try {
      Member member = await memberByCompanycodeApi.get(companycode);
      await prefs.setString('memberData', member.toJson());
      await prefs.setString('companycode', member.companycode!);

      return member;
    } catch (e) {
      log.severe("Error fetching member public: $e");
      return null;
    }
  }

  // this should be used everywhere in the app except login
  Future<Member?> getMemberPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var memberData = prefs.getString('memberData');
    if (memberData == null) {
      return null;
    }

    return Member.fromJson(json.decode(memberData));
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('token');
    prefs.remove('userInfoData');
    prefs.remove('memberData');
    prefs.remove('companycode');

    return true;
  }

  Future<dynamic> getUserInfo({withFetch=true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userInfoData = prefs.getString('userInfoData');
    if (userInfoData == null) {
      if (!withFetch) {
        return null;
      }

      final url = await getUrl('/company/user-info-me/');
      final token = prefs.getString('token');
      final res = await _httpClient.get(
          Uri.parse(url),
          headers: getHeaders(token)
      );

      if (res.statusCode == 200) {
        userInfoData = res.body;
        await prefs.setString('userInfoData', userInfoData);
      }
    }

    if (userInfoData == null) {
      log.warning("Could not determine user");
      return;
    }

    var userInfoDataDecoded = json.decode(userInfoData);

    if (userInfoDataDecoded['submodel'] == 'planning_user') {
      return PlanningUser.fromJson(userInfoDataDecoded['user']);
    }

    if (userInfoDataDecoded['submodel'] == 'employee_user') {
      return EmployeeUser.fromJson(userInfoDataDecoded['user']);
    }

    return null;
  }

  Future<String?> getLanguageCode(String? contextLanguageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode;

    // check the default language
    if (!prefs.containsKey('preferred_language_code')) {
      if (contextLanguageCode != null) {
        log.info("Setting preferred language from device to: $contextLanguageCode");
        await prefs.setString('preferred_language_code', contextLanguageCode);
      } else {
        log.info('not setting contextLanguageCode, it\'s null');
      }
    } else {
      languageCode = prefs.getString('preferred_language_code');
      if (languageCode != null) {
        await prefs.setString('preferred_language_code', languageCode);
      }
    }

    return prefs.getString('preferred_language_code');
  }
}

Utils utils = Utils();
