// TODO create directories for all models with API
class MinimalUser {
  final int? id;
  final String? email;
  final String? username;
  final String? fullName;
  final String? firstName;
  final String? lastName;

  MinimalUser({
    this.id,
    this.email,
    this.username,
    this.fullName,
    this.firstName,
    this.lastName,
  });

  factory MinimalUser.fromJson(Map<String, dynamic> parsedJson) {
    return MinimalUser(
      id: parsedJson['pk'],
      email: parsedJson['email'],
      username: parsedJson['username'],
      fullName: parsedJson['full_name'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
    );
  }
}

class StreamInfo {
  final String? apiKey;
  final String? token;
  final String? channelId;
  final String? channelTitle;
  final String? memberUserId;
  final MinimalUser? user;

  StreamInfo({
    this.apiKey,
    this.token,
    this.channelId,
    this.channelTitle,
    this.memberUserId,
    this.user
  });

  factory StreamInfo.fromJson(Map<String, dynamic> parsedJson) {
    MinimalUser user = MinimalUser.fromJson(parsedJson['user']);

    return StreamInfo(
      apiKey: parsedJson['api_key'],
      token: parsedJson['token'],
      channelId: parsedJson['channel_id'],
      channelTitle: parsedJson['channel_title'],
      memberUserId: parsedJson['member_user_id'],
      user: user
    );
  }
}

class PlanningUser {
  final int? id;
  final String? email;
  final String? username;
  final String? fullName;
  final String? firstName;
  final String? lastName;
  StreamInfo? streamInfo;

  PlanningUser({
    this.id,
    this.email,
    this.username,
    this.fullName,
    this.firstName,
    this.lastName,
  });

  factory PlanningUser.fromJson(Map<String, dynamic> parsedJson) {
    return PlanningUser(
        id: parsedJson['id'],
        email: parsedJson['email'],
        username: parsedJson['username'],
        fullName: parsedJson['fullName'],
        firstName: parsedJson['first_name'],
        lastName: parsedJson['last_name'],
    );
  }
}

class EmployeeProperty {
  final int? branch;

  EmployeeProperty({
    this.branch,
  });

  factory EmployeeProperty.fromJson(Map<String, dynamic> parsedJson) {
    return EmployeeProperty(
      branch: parsedJson['branch'],
    );
  }
}

class EmployeeUser {
  final int? id;
  final String? email;
  final String? username;
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final EmployeeProperty? employee;

  EmployeeUser({
    this.id,
    this.email,
    this.username,
    this.fullName,
    this.firstName,
    this.lastName,
    this.employee
  });

  factory EmployeeUser.fromJson(Map<String, dynamic> parsedJson) {
    return EmployeeUser(
      id: parsedJson['id'],
      email: parsedJson['email'],
      username: parsedJson['username'],
      fullName: parsedJson['fullName'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      employee: EmployeeProperty.fromJson(parsedJson['employee_user']),
    );
  }
}

class Branch {
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
