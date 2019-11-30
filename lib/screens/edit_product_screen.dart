import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/products.dart';
import '../providers/product.dart';


class EditProductScreen extends StatefulWidget {

  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocused = FocusNode();
  final _descriptionFocusedNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>(); //use to connecting the STATE WIDGETS of the FROM....

  var _editedProduct = Product( //assigning the value to the property of the Product Class
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        
      _editedProduct = Provider.of<Products>(context, listen: false).findById(productId);
      _initValues = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
        // 'imageUrl': _editedProduct.imageUrl,
        'imageUrl': '',
      };

      _imageUrlController.text = _editedProduct.imageUrl;

      }

    }
    _isInit = false;
    super.didChangeDependencies();
  }


  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocused.dispose();
    _descriptionFocusedNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {

      if (_imageUrlController.text.isEmpty || 
      (!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https')) || 
      (!_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.jpeg'))) 
      {
        
        return;

      }




      setState(() {

      });
    }

  }


//save the form values
 Future<void> _saveForm() async {

    setState(() {
      _isLoading = true;
    });

    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    if (_editedProduct.id != null) {

      try{

       await Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);

      }catch(error) {

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error in updating the inputs'),
            content: Text('Please the check the internet connection or contact egnimos'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        );

      }
      
    }else {

      try {
   
        await Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
        
        }catch(error) {

          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Error is being occured'),
              content: Text('Please check your internet connectivity, and if the problem persist then contact at egnimos.com'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            )
          );

        }
        // finally {

        //     setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.of(context).pop();

        // }
        
       
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();

  
    // Navigator.of(context).pop();

    // print(_editedProduct.title);
    // print(_editedProduct.price);
    // print(_editedProduct.description);
    // print(_editedProduct.imageUrl);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),

      body: _isLoading ? 
      Center(
        child: CircularProgressIndicator(),
      ) : 
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[

              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocused);
                },
                validator: (values) {
                  if (values.isEmpty) {
                    return 'Please provide the Title';
                  }
                  return null;
                },
                onSaved: (values) {
                  _editedProduct = Product(
                    title: values,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),

              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocused,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusedNode);
                },
                validator: (values) {
                  if (values.isEmpty) {
                    return 'Please provide the Price ';
                  }
                  if (double.tryParse(values) == null) {
                    return 'Please provide the valid Price';
                  }
                  if (double.parse(values) <= 0) {
                    return 'Please enter the valid price';
                  }

                  return null;
                },
                onSaved: (values) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(values),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),

              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusedNode,
                validator: (values) {
                  if (values.isEmpty) {
                    return 'Please provide the valid input';
                  }
                  if (values.length <20) {
                    return 'Description should be more than 20 characters';
                  }
                  return null;
                },
                onSaved: (values) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: values,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10,),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty ? Text('Enter the URL') : FittedBox(
                      child: Image.network(_imageUrlController.text),
                      fit: BoxFit.cover,
                      ),
                  ),

                  Expanded(
                      child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (values) {
                        if (values.isEmpty) {
                          return 'Please provide the image url';
                        }
                        if (!values.startsWith('http') && !values.startsWith('https')) {
                          return 'Please provide the valid input in the image url';
                        }
                        if (!values.endsWith('.png') && !values.endsWith('.jpg') && !values.endsWith('.jpeg')) {
                          return 'Given image url does not end with the valid extension Provide the valid input';
                        }
                        return null;
                      },
                      onSaved: (values) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: values,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                ],
              )

            ],
          ),

        ),
      )
    );
  }
}