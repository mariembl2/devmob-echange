import 'package:flutter/material.dart';
import 'package:dev_mob/models/item.dart';

class ItemDetailPage extends StatelessWidget {
  final ItemModel item;

  const ItemDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage des images
            if (item.imageUrls.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: item.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        item.imageUrls[index],
                        fit: BoxFit.cover,
                        width: 200,
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.grey[300],
                child: Center(
                  child: Text('Aucune image disponible'),
                ),
              ),
            SizedBox(height: 16),

            // Titre de l'objet
            Text(
              item.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Description de l'objet
            Text(
              item.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Prix par jour
            Row(
              children: [
                Icon(Icons.attach_money, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  item.isFree
                      ? 'Gratuit'
                      : '${item.pricePerDay.toStringAsFixed(2)} € / jour',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Localisation
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  item.location,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Bouton pour réserver
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Naviguer vers la page de réservation
                  Navigator.pushNamed(context, '/reservation', arguments: item);
                },
                child: Text('Réserver cet objet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}