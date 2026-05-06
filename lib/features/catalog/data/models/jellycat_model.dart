import '../../domain/entities/jellycat_entity.dart';

class JellycatModel extends JellycatEntity {
  JellycatModel({
    required super.id,
    required super.name,
    required super.category,
    required super.status,
    required super.priceGbp,
    super.isOwned,
  });
}
