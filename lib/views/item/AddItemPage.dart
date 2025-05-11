import 'package:flutter/material.dart';
import 'package:dev_mob/models/item.dart';
import 'package:dev_mob/services/ItemService.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController(); // Nouveau champ pour l'URL de l'image

  bool _isLoading = false;

  void _addItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final newItem = ItemModel(
          id: '', // L'ID sera généré automatiquement par Firestore
          ownerId: 'currentUserId', // Remplacez par l'ID de l'utilisateur connecté
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          imageUrls: [
            _imageUrlController.text.trim(), // Ajouter l'URL de l'image dans le modèle
          ],
          pricePerDay: double.tryParse(_priceController.text.trim()) ?? 0.0,
          category: _categoryController.text.trim(),
          location: _locationController.text.trim(),
          createdAt: DateTime.now(),
          reservedDates: [],
        );

        await ItemService().addItem(newItem);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Objet ajouté avec succès !')),
        );

        Navigator.pop(context); // Retour à la page précédente
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un objet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Prix par jour (en €)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un prix valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une catégorie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Localisation',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une localisation';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,  // Champ pour l'URL de l'image
                decoration: InputDecoration(
                  labelText: 'URL de l\'image',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une URL d\'image';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _addItem,
                      child: Text('Ajouter l\'objet'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();  // Ne pas oublier de disposer du contrôleur de l'URL de l'image
    super.dispose();
  }
}
