import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageURLFocus = FocusNode();
  final _imageURLController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageURLFocus.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageURLFocus.dispose();
    _imageURLFocus.removeListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    final newProduct = Product(
      id: Random().nextDouble().toString(),
      title: _formData['name'] as String,
      description: _formData['description'] as String,
      price: _formData['price'] as double,
      imageUrl: _formData['imageURL'] as String,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulário de Produto"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nome",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: (_name) {
                  final name = _name ?? '';

                  if (name.trim().isEmpty) {
                    return "Nome é obrigatório";
                  }

                  if (name.trim().length < 3) {
                    return "Nome precisa ter no mínimo de 3 letras";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Preço",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                focusNode: _priceFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (price) =>
                    _formData['price'] = double.parse(price ?? '0'),
                validator: (_price) {
                  final priceString = _price ?? "";
                  final price = double.tryParse(priceString) ?? -1;
                  if (price <= 0) {
                    return "Informe um preço válido!";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Descrição",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                focusNode: _descriptionFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (description) =>
                    _formData['description'] = description ?? '',
                validator: (_description) {
                  final description = _description ?? '';

                  if (description.trim().isEmpty) {
                    return "Descrição é obrigatório";
                  }

                  if (description.trim().length < 10) {
                    return "Descrição precisa ter no mínimo de 10 letras";
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "URL da Imagem",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                      ),
                      focusNode: _imageURLFocus,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageURLController,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (imageURL) =>
                          _formData['imageURL'] = imageURL ?? '',
                      validator: (_imageURL) {
                        final imageUrl = _imageURL ?? "";
                        if (!isValidImageUrl(imageUrl)) {
                          return "Informe uma URL válida!";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageURLController.text.isEmpty
                        ? Text("Informe a URL")
                        : FittedBox(
                            child: Image.network(_imageURLController.text),
                            fit: BoxFit.cover,
                          ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
