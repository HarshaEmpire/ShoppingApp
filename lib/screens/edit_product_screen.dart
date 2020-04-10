import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as pth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/product.dart';
import '../Providers/products.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus1 = FocusNode();
  final _priceFocus2 = FocusNode();
  final _urlController = TextEditingController();
  final _imageFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  File _storedImage;
  var _product = Product(
      id: null, title: null, price: null, description: null, imageUrl: null);
  var _init = true;
  var _isLoading = false;
  var _isSmallLoading=false;
  var _initproduct = {
    "title": "",
    "price": "",
    "description": "",
    "imageUrl": "",
  };
  

  void initState() {
    _imageFocus.addListener(_listener);
  }

  void didChangeDependencies() {
    if (_init) {
      var productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _product = Provider.of<Products>(context, listen: false)
            .items
            .firstWhere((tx) {
          return tx.id == productId;
        });
        _initproduct = {
          "title": _product.title,
          "price": _product.price.toString(),
          "description": _product.description,
          "imageUrl": _product.imageUrl,
        };
        _urlController.text = _product.imageUrl;

      }
    }
    _init = false;
  }

  @override
  void dispose() {
    _priceFocus1.dispose();
    _priceFocus2.dispose();
    _imageFocus.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _listener() {
    if (!_urlController.text.startsWith("https") &&
        !_urlController.text.startsWith("http")) return;
    if (!_imageFocus.hasFocus) setState(() {});
  }

  void _save() {
    setState(() {
      _isLoading = true;
    });
    final _isValid = _formKey.currentState.validate();
    if (_isValid) {
      _formKey.currentState.save();
      if (_product.id != null) {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_product.id, _product)
            .then((_) {
          // setState(() {
          //   _isLoading=false;
          // });
          Navigator.of(context).pop();
        });
      } else {
        Provider.of<Products>(context, listen: false)
            .addProduct(_product)
            .catchError((err) {
          return showDialog<Null>(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text(
                      "oops error occured",
                    ),
                    content: Text("Try Again"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          "Ok",
                        ),
                      )
                    ],
                  ));
        }).then((_) {
          // setState(() {
          //   _isLoading=false;
          // });
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> take_image() async {
    FocusScope.of(context).requestFocus(_imageFocus);
    try{
    final _image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      maxHeight: 600,
    );
    setState(() {
      _isSmallLoading = true;
    });
    String _filename=pth.basename(_image.path);
    StorageReference _store=FirebaseStorage.instance.ref().child(_filename);
    StorageUploadTask upload=_store.putFile(_image);
    StorageTaskSnapshot snap=await upload.onComplete;
    final res=await _store.getDownloadURL(); 
    setState(() {
      _urlController.text=res;
      _isSmallLoading=false;
    });
    }
    catch(err){
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("hello");
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          _isSmallLoading==true?FittedBox(child:CircularProgressIndicator(),fit: BoxFit.scaleDown,):
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _save,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initproduct["title"],
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus1);
                        },
                        validator: (val) {
                          if (val.isEmpty)
                            return "enter the Title";
                          else
                            return null;
                        },
                        onSaved: (val) {
                          _product = Product(
                              isFavourite: _product.isFavourite,
                              id: _product.id,
                              title: val,
                              price: 0,
                              description: "",
                              imageUrl: "");
                        },
                      ),
                      TextFormField(
                        initialValue: _initproduct["price"],
                        
                        decoration: InputDecoration(labelText: "Price"),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocus1,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus2);
                        },
                        validator: (val) {
                          if (val.isEmpty) return "Please Enter A Value";
                          if (double.tryParse(val) == null)
                            return "Please Enter A Number";
                          if (double.parse(val) <= 0)
                            return "Please Enter A Positive Number";
                          return null;
                        },
                        onSaved: (val) {
                          _product = Product(
                              isFavourite: _product.isFavourite,
                              id: _product.id,
                              title: _product.title,
                              price: double.parse(val),
                              description: "",
                              imageUrl: "");
                        },
                      ),
                      TextFormField(
                        initialValue: _initproduct["description"],
                        decoration: InputDecoration(labelText: "Description"),
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        focusNode: _priceFocus2,
                        validator: (val) {
                          if (val.isEmpty) return "Enter the discription";
                          return null;
                        },
                        onSaved: (val) {
                          _product = Product(
                              isFavourite: _product.isFavourite,
                              id: _product.id,
                              title: _product.title,
                              price: _product.price,
                              description: val,
                              imageUrl: "");
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.all(7),
                            decoration:
                                BoxDecoration(border: Border.all(width: 2)),
                            child: _urlController.text.isEmpty &&
                                    _storedImage == null
                                ? Center(
                                    child: Text("enter the Url"),
                                  )
                                : _urlController.text.isNotEmpty
                                    ? FittedBox(
                                        child:
                                            Image.network(_urlController.text),
                                      )
                                    : Image.file(
                                        _storedImage,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                          ),
                          Expanded(
                            child: TextFormField(
                              // initialValue: _initproduct["imageurl"],
                              decoration: InputDecoration(labelText: "Url"),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _urlController,
                              focusNode: _imageFocus,
                              validator: (val) {
                                if (val.isEmpty) return "Enter The Url";
                                return null;
                              },
                              // onFieldSubmitted: (_) {
                              //   _save();
                              // },
                              onSaved: (val) {
                                _product = Product(
                                    isFavourite: _product.isFavourite,
                                    id: _product.id,
                                    title: _product.title,
                                    price: _product.price,
                                    description: _product.description,
                                    imageUrl: val);
                              },
                            ),
                          ),
                          FlatButton.icon(
                            onPressed: () {
                              take_image();
                            },
                            icon: Icon(Icons.camera),
                            label: Text("take image"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
