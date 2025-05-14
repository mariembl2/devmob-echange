import 'package:dev_mob/models/item_model.dart';
import 'package:dev_mob/views/home/custom_search_bar.dart';
import 'package:dev_mob/widgets/ItemCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ItemListView extends StatefulWidget {
  @override
  _ItemListViewState createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  String query = ''; // Recherche actuelle

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<List<ItemModel>>(context);

    // Filtrage basé sur le titre
    final filteredItems = items.where((item) {
      return item.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Objets disponibles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomSearchBar(
              onSearch: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredItems.isEmpty
                  ? const Center(child: Text("Aucun objet trouvé"))
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ItemCard(item: item); // Intégration ici
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
