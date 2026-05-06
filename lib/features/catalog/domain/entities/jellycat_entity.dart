class JellycatEntity {
  final String id;
  final String name;
  final String category;
  final String status;
  final double priceGbp;
  final bool isOwned;

  JellycatEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.priceGbp,
    this.isOwned = false,
  });
}
