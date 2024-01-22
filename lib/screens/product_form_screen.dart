import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageURLFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageURLController.text = product.imageUrl;
      }
    }
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



  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formData);
      Navigator.of(context).pop();
      
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Ocorreu um Erro"),
          content: Text("Ocorreu um Erro ao salvar o produto"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("ok"),
            )
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulário de Produto"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
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
                      initialValue: _formData['price']?.toString(),
                      decoration: InputDecoration(
                        labelText: "Preço",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
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
                      initialValue: _formData['description']?.toString(),
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
                                _formData['imageUrl'] = imageURL ?? '',
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
                              ? const Text("Informe a URL")
                              : Image.network(_imageURLController.text),
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
