import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:laundryproject/lostproduct.dart';
import '../products.dart';
import '../widgets/image_input.dart';
import 'package:provider/provider.dart';

import 'dart:io';

class AddScreen extends StatefulWidget {
  static const routeName = '/add_item';
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File _pickedImage;
  var _isLoading = false;

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://nulaundry-a4c31.appspot.com');

  StorageUploadTask _uploadTask;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  Future<void> _saveitem() async {
    setState(() {
      _isLoading = true;
    });
    if (_titleController.text.isEmpty || _pickedImage == null) {
      return;
    }
    String filePath = 'images/${DateTime.now()}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(_pickedImage);
    });
    var downloadUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    var _imageurl = downloadUrl.toString();

    await Provider.of<Products>(context, listen: false)
        .additem(
      _titleController.text,
      _descriptionController.text,
      _imageurl,
    )
        .then((_) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new request'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(labelText: 'Title'),
                            controller: _titleController,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration:
                                InputDecoration(labelText: 'Description'),
                            controller: _descriptionController,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ImageInput(_selectImage), //custom widget
                        ],
                      ),
                    ),
                  ),
                ),
                RaisedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add request'),
                  onPressed: _saveitem,
                  elevation: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  color: Theme.of(context).accentColor,
                )
              ],
            ),
    );
  }
}
