// To parse this JSON data, do
//
//     final favorite = favoriteFromJson(jsonString);

import 'dart:convert';

List<Favorite> favoriteFromJson(String str) => List<Favorite>.from(json.decode(str).map((x) => Favorite.fromJson(x)));

String favoriteToJson(List<Favorite> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Favorite {
    int id;
    int userId;
    int serviceId;
    bool isChecked;
    dynamic createdAt;
    dynamic updatedAt;
    Service service;

    Favorite({
        required this.id,
        required this.userId,
        required this.serviceId,
        required this.isChecked,
        required this.createdAt,
        required this.updatedAt,
        required this.service,
    });

    factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json["id"],
        userId: json["user_id"],
        serviceId: json["service_id"],
        isChecked: json["is_checked"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        service: Service.fromJson(json["service"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_id": serviceId,
        "is_checked": isChecked,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "service": service.toJson(),
    };
}

class Service {
    int id;
    int serviceProviderId;
    String title;
    String description;
    String price;
    String duration;
    DateTime createdAt;
    DateTime updatedAt;
    ServiceProvider serviceProvider;

    Service({
        required this.id,
        required this.serviceProviderId,
        required this.title,
        required this.description,
        required this.price,
        required this.duration,
        required this.createdAt,
        required this.updatedAt,
        required this.serviceProvider,
    });

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        serviceProviderId: json["service_provider_id"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        duration: json["duration"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        serviceProvider: ServiceProvider.fromJson(json["service_provider"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "service_provider_id": serviceProviderId,
        "title": title,
        "description": description,
        "price": price,
        "duration": duration,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "service_provider": serviceProvider.toJson(),
    };
}

class ServiceProvider {
    int id;
    int userId;
    String serviceType;
    String description;
    String address;
    String latitude;
    String longitude;
    String rating;
    DateTime createdAt;
    DateTime updatedAt;
    User user;

    ServiceProvider({
        required this.id,
        required this.userId,
        required this.serviceType,
        required this.description,
        required this.address,
        required this.latitude,
        required this.longitude,
        required this.rating,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
    });

    factory ServiceProvider.fromJson(Map<String, dynamic> json) => ServiceProvider(
        id: json["id"],
        userId: json["user_id"],
        serviceType: json["service_type"],
        description: json["description"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        rating: json["rating"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_type": serviceType,
        "description": description,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "rating": rating,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toJson(),
    };
}

class User {
    int id;
    String name;
    String email;
    dynamic emailVerifiedAt;
    String phone;
    String avatar;
    String address;
    String lastname;
    DateTime createdAt;
    DateTime updatedAt;

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
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        phone: json["phone"],
        avatar: json["avatar"],
        address: json["address"],
        lastname: json["lastname"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "phone": phone,
        "avatar": avatar,
        "address": address,
        "lastname": lastname,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
