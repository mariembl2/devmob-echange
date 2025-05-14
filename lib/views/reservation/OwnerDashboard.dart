import 'package:dev_mob/services/ItemService.dart';
import 'package:dev_mob/views/item/EditItemPage.dart';
import 'package:dev_mob/views/item/ItemDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dev_mob/models/item_model.dart';

class OwnerDashboard extends StatelessWidget {
  final ItemService itemService = ItemService();

  OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tableau de bord')),
        body: const Center(child: Text('Utilisateur non connecté.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes objets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/add-item'),
          ),
        ],
      ),
      body: StreamBuilder<List<ItemModel>>(
        stream: itemService.getItemsByOwner(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text('Erreur : ${snapshot.error}'));

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('Vous n\'avez encore ajouté aucun objet.'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: item.imageUrls.isNotEmpty
                      ? Image.network(
                          item.imageUrls.first,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported, size: 50),
                  title: Text(item.title),
                  subtitle: Text('${item.category} • ${item.location}\n${item.pricePerDay} € / jour'),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItemDetailPage(item: item),
                      ),
                    );
                  },
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditItemPage(item: item),
                          ),
                        );
                      } else if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Supprimer'),
                            content: const Text('Voulez-vous vraiment supprimer cet objet ?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Supprimer'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await itemService.deleteItem(item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Objet supprimé.')),
                          );
                        }
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('Modifier')),
                      PopupMenuItem(value: 'delete', child: Text('Supprimer')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
