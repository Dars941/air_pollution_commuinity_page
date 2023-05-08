class Post {
  final String id;
  final String title;
  final String description;
  final String image;
  final String location;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.location,
  });

  factory Post.fromMap(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'location': location,
    };
  }
}
