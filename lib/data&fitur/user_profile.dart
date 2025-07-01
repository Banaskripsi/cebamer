class UserProfile {
  UserProfile({
    required this.username,
    required this.uid,
    required this.role,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    role = json['role'];
  }

  String? username;
  String? uid;
  String? role;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['username'] = username;
    data['role'] = role;

    return data;
  }
}