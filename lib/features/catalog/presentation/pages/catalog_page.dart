import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalog_provider.dart';

class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jellycat 图鉴与库存'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: catalog.length,
        itemBuilder: (context, index) {
          final item = catalog[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              // 【新增这里】当手指点击这一行时触发
              onTap: () {
                // 通知 Notifier 执行 toggleOwnership 方法
                ref.read(catalogProvider.notifier).toggleOwnership(item.id);
              },
              leading: CircleAvatar(
                backgroundColor: item.isOwned ? Colors.green : Colors.grey.shade300,
                child: Icon(
                  item.isOwned ? Icons.check : Icons.favorite_border,
                  color: item.isOwned ? Colors.white : Colors.grey,
                ),
              ),
              title: Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${item.category} • ${item.status}'),
              trailing: Text(
                '£${item.priceGbp.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF005b96),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
