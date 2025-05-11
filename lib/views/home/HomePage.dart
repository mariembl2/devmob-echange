import 'package:dev_mob/views/item/ItemDetailPage.dart';
import 'package:dev_mob/views/item/AddItemPage.dart'; // Assure-toi d'importer AddItemPage
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dev_mob/models/item.dart';  

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Récupère la liste des objets via le provider
    final items = Provider.of<List<ItemModel>>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("DEVMOB - Échange"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Ajouter la logique de recherche ici
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: items.isEmpty
            ? Center(child: CircularProgressIndicator())  // Chargement des objets
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.description),
                    leading: Icon(Icons.image),  // Image de l'objet, tu peux le changer
                    onTap: () {
                      // Redirection vers la page de détails de l'objet
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailPage(item: item),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers la page pour ajouter un nouvel objet
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemPage()), // Redirection vers AddItemPage
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Ajouter un objet',
      ),
    );
  }
}
