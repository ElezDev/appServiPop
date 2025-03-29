class User {
    User({
        required this.id,
        required this.name,
        required this.email,
        required this.emailVerifiedAt,
        required this.phone,
        required this.avatar,
        required this.address,
        required this.lastname,
        required this.createdAt,
        required this.updatedAt,
        required this.roles,
        required this.permissions,
    });

    final int? id;
    final String? name;
    final String? email;
    final dynamic emailVerifiedAt;
    final String? phone;
    final String? avatar;
    final String? address;
    final String? lastname;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final List<Role> roles;
    final List<dynamic> permissions;

    factory User.fromJson(Map<String, dynamic> json){ 
        return User(
            id: json["id"],
            name: json["name"],
            email: json["email"],
            emailVerifiedAt: json["email_verified_at"],
            phone: json["phone"],
            avatar: json["avatar"],
            address: json["address"],
            lastname: json["lastname"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
            permissions: json["permissions"] == null ? [] : List<dynamic>.from(json["permissions"]!.map((x) => x)),
        );
    }

}

class Role {
    Role({
        required this.id,
        required this.name,
        required this.guardName,
        required this.createdAt,
        required this.updatedAt,
        required this.pivot,
    });

    final int? id;
    final String? name;
    final String? guardName;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Pivot? pivot;

    factory Role.fromJson(Map<String, dynamic> json){ 
        return Role(
            id: json["id"],
            name: json["name"],
            guardName: json["guard_name"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
        );
    }

}

class Pivot {
    Pivot({
        required this.modelType,
        required this.modelId,
        required this.roleId,
    });

    final String? modelType;
    final int? modelId;
    final int? roleId;

    factory Pivot.fromJson(Map<String, dynamic> json){ 
        return Pivot(
            modelType: json["model_type"],
            modelId: json["model_id"],
            roleId: json["role_id"],
        );
    }

}
