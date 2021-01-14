import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_note_with_image/helper/note_provider.dart';
import 'package:take_note_with_image/models/note.dart';
import 'package:take_note_with_image/utils/constants.dart';
import 'package:take_note_with_image/widgets/delete_popup.dart';

import 'note_edit_screen.dart';

class NoteViewScreen extends StatefulWidget {
  static const route = '/note-view';

  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State {

  Note selectedNote;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context).settings.arguments;
    final provider = Provider.of<NoteProvider>(context, listen: false);
    if (provider.getNote(id) != null) {
      selectedNote = provider.getNote(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: headerColor,
      appBar: selectedNote.imagePath != null ? null : AppBar(
        elevation: 0.7,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () => _showDialog(),
          ),
        ],
      ),
      /*appBar: AppBar(
        elevation: 0.7,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () => _showDialog(),
          ),
        ],
      ),*/
      body: selectedNote.imagePath != null ?CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height*0.5,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                onPressed: () => _showDialog(),
              ),
            ],
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100)
              )
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(selectedNote?.title,
                style: viewTitleStyle,),
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(43.0),
                  bottomLeft: Radius.circular(43.0)
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Image.file(File(selectedNote.imagePath), fit: BoxFit.cover,),
                ),
              )
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index){
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        selectedNote.content,
                        style: viewContentStyle,
                      ),
                    )
                  );
                },
              childCount: 1,
            ),
          )
        ],
      ): SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedNote?.title,
                style: viewTitleStyle,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.access_time,
                    size: 18,
                  ),
                ),
                Text('${selectedNote?.date}')
              ],
            ),
            /*if (selectedNote.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.file(File(selectedNote.imagePath)),
              ),*/
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                selectedNote.content,
                style: viewContentStyle,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: headerColor,
        onPressed: () {
          Navigator.pushNamed(context, NoteEditScreen.route,
              arguments: selectedNote.id);
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DeletePopUp(selectedNote: selectedNote);
        });
  }
}
