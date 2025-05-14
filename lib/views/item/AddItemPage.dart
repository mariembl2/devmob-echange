import 'package:dev_mob/models/item_model.dart';
import 'package:dev_mob/providers/AuthProvider.dart';
import 'package:dev_mob/services/ItemService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Contrôleurs pour les champs du formulaire
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un objet'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Prix par jour'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'URL de l\'image'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une URL d\'image';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Lieu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un lieu';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Catégorie'),
                items: ['Transport', 'Vêtements', 'Électronique', 'Autres']
                    .map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une catégorie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _addItem,
                      child: Text('Ajouter'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour ajouter un item
  void _addItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Récupérer l'utilisateur actuellement connecté via AuthProvider
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final currentUser = authProvider.user;

        if (currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vous devez être connecté pour ajouter un objet')),
          );
          return;
        }

        final currentUserId = currentUser.uid;

        // Crée un nouvel objet avec les données du formulaire
        final newItem = ItemModel(
          id: '', // L'ID sera généré automatiquement par Firestore
          ownerId: currentUserId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          imageUrls: [_imageUrlController.text.trim()],
          pricePerDay: double.tryParse(_priceController.text.trim()) ?? 0.0,
          category: _selectedCategory ?? '',
          location: _locationController.text.trim(),
          createdAt: DateTime.now(),
          reservedDates: [], // Liste vide de dates réservées par défaut
        );

        // Enregistrer l'item dans Firestore via ItemService
        await ItemService().addItem(newItem);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Objet ajouté avec succès !')),
        );

        Navigator.pop(context); // Retour à la page précédente après l'ajout
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
