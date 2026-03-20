import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiSelectInput extends StatefulWidget {
  @override
  _ApiSelectInputState createState() => _ApiSelectInputState();
}

class _ApiSelectInputState extends State<ApiSelectInput> {
  List<dynamic> _items = [];
  dynamic _selectedItem;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.example.com/items'), // Remplacez par votre URL
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _items = data['items'] ?? []; // Adaptez selon la structure de votre API
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Erreur de chargement: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de connexion: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select avec Données API')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Text(_errorMessage!, style: TextStyle(color: Colors.red))
                    : DropdownButtonFormField<dynamic>(
                        value: _selectedItem,
                        decoration: InputDecoration(
                          labelText: 'Sélectionnez un élément',
                          border: OutlineInputBorder(),
                        ),
                        items: _items.map<DropdownMenuItem<dynamic>>((item) {
                          return DropdownMenuItem<dynamic>(
                            value: item,
                            child: Text(
                              item['name'] ?? 'Sans nom', // Adaptez selon votre structure
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedItem = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Veuillez sélectionner un élément';
                          }
                          return null;
                        },
                      ),
            SizedBox(height: 20),
            if (_selectedItem != null)
              Text(
                'Élément sélectionné: ${_selectedItem['name']} (ID: ${_selectedItem['id']})',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedItem != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Élément soumis: ${_selectedItem['name']}'),
                    ),
                  );
                }
              },
              child: Text('Soumettre'),
            ),
          ],
        ),
      ),
    );
  }
}