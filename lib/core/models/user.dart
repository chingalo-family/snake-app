class User {
  late String id;
  late String username;
  late String fullName;
  late String? password;
  late String? email;
  late String? gender;
  late String? phoneNumber;
  List<String>? userOrgUnitIds;
  late bool isLogin;

  User({
    required this.id,
    required this.username,
    this.email,
    required this.fullName,
    required this.password,
    this.phoneNumber,
    this.gender,
    this.isLogin = false,
    this.userOrgUnitIds = const [],
  });

  Map<String, dynamic> toMap() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['fullName'] = fullName;
    data['password'] = password;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['isLogin'] = isLogin ? '1' : '0';
    data['userOrgUnitIds'] = userOrgUnitIds?.join(',') ?? '';
    return data;
  }

  User.fromMap(Map mapData) {
    id = mapData['id'];
    username = mapData['username'];
    fullName = mapData['fullName'];
    password = mapData['password'];
    email = mapData['email'];
    phoneNumber = mapData['phoneNumber'];
    userOrgUnitIds = '${mapData['userOrgUnitIds']}'.split(';');
    isLogin = mapData['isLogin'] == '1';
  }

  factory User.fromJson(dynamic json, String username, String password) {
    List organisationUnitList = json['organisationUnits'] as List<dynamic>;
    return User(
      fullName: json['name'],
      id: json['id'],
      password: password,
      username: username,
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      isLogin: true,
      userOrgUnitIds: organisationUnitList
          .map((organisationUnit) => '${organisationUnit["id"]}')
          .toList(),
    );
  }

  @override
  String toString() {
    return 'User <$id : $username>';
  }
}
