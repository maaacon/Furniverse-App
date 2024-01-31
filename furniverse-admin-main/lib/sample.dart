import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path/path.dart';

class Sample extends StatefulWidget {
  const Sample({super.key});

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {

  
   UploadTask? uploadTask;
   File? file;

  // List<QueryDocumentSnapshot> data = [];
  String samplee = '';
   String src = "https://firebasestorage.googleapis.com/v0/b/furniverse-5f170.appspot.com/o/threedifiles%2FAstronaut.glb%2Fdata%2Fuser%2F0%2Fcom.example.furniverse_admin%2Fcache%2Ffile_picker%2FAstronaut.glb?alt=media&token=21afbfe5-b636-4e7b-b9d6-48827c6a0435";

  @override
  Widget build(BuildContext context) {

    // var fileName = file != null ? basename(file!.path) : "No file is selected";
    // final Storage storage = Storage();
    return Scaffold(
      body: 
      
      ModelViewer(
          backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
          src: src,
          alt: 'A 3D model of an astronaut',
          ar: true,
          autoRotate: true,
          iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
          disableZoom: true,
        ),


      // Column(
      //   children: [
          
      //     ElevatedButton(onPressed: (){selectFile();}, child: Text("select file")),

      //     Text(fileName),

      //     Image.network("https://firebasestorage.googleapis.com/v0/b/furniverse-5f170.appspot.com/o/threedifiles%2FIMG_20231025_085855.jpg?alt=media&token=a1549408-227e-411c-a449-c45916246293"),

      //     ElevatedButton(onPressed: () async {
      //       // final path = result?.files.single.path!;
      //       // final fileName = result?.files.single.name;
      //       // // final ref = FirebaseStorage.instance.ref().child(path!);
      //       // File file = File(path!);

      //       // print(path);
      //       // print(fileName);
      //       uploadFile();
            


      //     }, child: Text("Upload file")),

      //     ElevatedButton(onPressed: () async { 
      //       _fetch();      
      //     }, child: Text("")),

          
          
          
      //   ],
      // ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.any,
            );
    if (result == null) return;

    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final sample =FirebaseStorage.instance.ref('threedifiles/$fileName');
            uploadTask = sample.putFile(file!);
            final snapshot = await uploadTask!.whenComplete((){});

            final urlDownload = await snapshot.ref.getDownloadURL();
            print(urlDownload);
            
            final product = FirebaseFirestore.instance.collection('products');
            final json = {
              'sample' : urlDownload,
            };

            await product.add(json);
  }


  // READ SPECIFIC DOCUMENT
  // sample palang since wala pang reading sa list na nagpapasa ng id nung product manual input muna ng id pero nakakaread na
   _fetch() async {
    
      await FirebaseFirestore.instance
          .collection('products').doc("75oy31sqCDeiT7NEgv8H")
          //.where("uid", isEqualTo: "Q3tRGI2r4n8rUkGArsla")
          .get()
          .then((ds) {
        samplee = "${ds["sample"]}";
        setState(() {
          
        });
        print(samplee);
      });
  }
}
