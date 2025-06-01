class JwtPayload {
  final int exp;
  final int iat;
  final int nbf;
  final String iss;
  final String sub;
  final String aud;
  final JwtUser user;

  JwtPayload({
    required this.exp,
    required this.iat,
    required this.nbf,
    required this.iss,
    required this.sub,
    required this.aud,
    required this.user,
  });

  factory JwtPayload.fromJson(Map<String, dynamic> json) {
    return JwtPayload(
      exp: json['exp'],
      iat: json['iat'],
      nbf: json['nbf'],
      iss: json['iss'],
      sub: json['sub'],
      aud: json['aud'],
      user: JwtUser.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exp': exp,
      'iat': iat,
      'nbf': nbf,
      'iss': iss,
      'sub': sub,
      'aud': aud,
      'user': user.toJson(),
    };
  }
}

class JwtUser {
  final String id;
  final String email;
  final String schoolId;
  final String roleId;

  JwtUser({
    required this.id,
    required this.email,
    required this.schoolId,
    required this.roleId,
  });

  factory JwtUser.fromJson(Map<String, dynamic> json) {
    return JwtUser(
      id: json['id'],
      email: json['email'],
      schoolId: json['school_id'],
      roleId: json['role_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'school_id': schoolId,
      'role_id': roleId,
    };
  }
}
