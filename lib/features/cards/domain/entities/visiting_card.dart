class VisitingCard {
  final int id;
  final String name;
  final String? jobTitle;
  final String? company;
  final String? email;
  final String? phone;
  final String? website;
  final String details;

  const VisitingCard({
    required this.id,
    required this.name,
    this.jobTitle,
    this.company,
    this.email,
    this.phone,
    this.website,
    required this.details,
  });

  VisitingCard copyWith({
    int? id,
    String? name,
    String? jobTitle,
    String? company,
    String? email,
    String? phone,
    String? website,
    String? details,
  }) {
    return VisitingCard(
      id: id ?? this.id,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      details: details ?? this.details,
    );
  }
}
