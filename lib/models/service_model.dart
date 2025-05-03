class Service {
  final int id;
  final int serviceProviderId;
  final String title;
  final String description;
  final double price;
  final int duration;
  final ServiceProvider serviceProvider;
  final List<PortfolioImage> portfolioImages;

  Service({
    required this.id,
    required this.serviceProviderId,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.serviceProvider,
    required this.portfolioImages,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      serviceProviderId: json['service_provider_id'],
      title: json['title'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      duration: int.parse(json['duration'].toString()),
      serviceProvider: ServiceProvider.fromJson(json['service_provider']),
      portfolioImages: (json['portfolio_images'] as List)
          .map((image) => PortfolioImage.fromJson(image))
          .toList(),
    );
  }
}

class ServiceProvider {
  final int id;
  final int userId;
  final String serviceType;
  final String description;
  final String address;
  final double rating;
  final User user;

  ServiceProvider({
    required this.id,
    required this.userId,
    required this.serviceType,
    required this.description,
    required this.address,
    required this.rating,
    required this.user,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'],
      userId: json['user_id'],
      serviceType: json['service_type'],
      description: json['description'],
      address: json['address'],
      rating: double.parse(json['rating'].toString()),
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String name;
  final String lastname;
  final String email;
  final String phone;
  final String avatar;
  final String address;

  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      address: json['address'],
    );
  }
}

class PortfolioImage {
  final int id;
  final String imageUrl;
  final String description;

  PortfolioImage({
    required this.id,
    required this.imageUrl,
    required this.description,
  });

  factory PortfolioImage.fromJson(Map<String, dynamic> json) {
    return PortfolioImage(
      id: json['id'],
      imageUrl: json['image_url'] ?? json['imageUrl'],
      description: json['description'],
    );
  }
}