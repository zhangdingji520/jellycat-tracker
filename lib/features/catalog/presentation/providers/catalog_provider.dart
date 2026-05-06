import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/jellycat_model.dart';

// 定义一个 Notifier，里面不仅存数据，还包含了修改数据的方法
class CatalogNotifier extends StateNotifier<List<JellycatModel>> {
  CatalogNotifier() : super([
    JellycatModel(id: '1', name: 'Snow Dragon Bag Charm', category: 'Bag Charms', status: 'Current', priceGbp: 25.0, isOwned: true),
    JellycatModel(id: '2', name: 'Bashful Beige Bunny', category: 'Bashfuls', status: 'Current', priceGbp: 22.0, isOwned: false),
    JellycatModel(id: '3', name: 'Amuseable Croissant', category: 'Amuseables', status: 'Retired', priceGbp: 18.0, isOwned: true),
  ]);

  // 这是一个核心动作：切换“是否拥有”的状态
  void toggleOwnership(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          // 如果找到了被点击的这一款，就把它的是否拥有状态反转（true 变 false，false 变 true）
          JellycatModel(
            id: item.id,
            name: item.name,
            category: item.category,
            status: item.status,
            priceGbp: item.priceGbp,
            isOwned: !item.isOwned, 
          )
        else
          item
    ];
  }
}

// 提供给前端界面的 Provider
final catalogProvider = StateNotifierProvider<CatalogNotifier, List<JellycatModel>>((ref) {
  return CatalogNotifier();
});
