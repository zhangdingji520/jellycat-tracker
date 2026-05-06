import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/jellycat_model.dart';

final catalogProvider = StateProvider<List<JellycatModel>>((ref) {
  return [
    JellycatModel(
      id: '1',
      name: 'Snow Dragon Bag Charm',
      category: 'Bag Charms',
      status: 'Current',
      priceGbp: 25.0,
      isOwned: true,
    ),
    JellycatModel(
      id: '2',
      name: 'Bashful Beige Bunny',
      category: 'Bashfuls',
      status: 'Current',
      priceGbp: 22.0,
      isOwned: false,
    ),
    JellycatModel(
      id: '3',
      name: 'Amuseable Croissant',
      category: 'Amuseables',
      status: 'Retired',
      priceGbp: 18.0,
      isOwned: true,
    ),
  ];
});
