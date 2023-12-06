import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_firebase_setup/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference moviesRef = _firestore.collection('movies');
    // var babaRef = _firestore.collection('movies').doc('Baba');
    var babaRef = moviesRef.doc('Baba');
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar:
            AppBar(title: Text('Firestore CRUD İşlemleri'), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
              ElevatedButton(
                onPressed: () async {
                  var response = await babaRef.get();
                  dynamic map = response.data();
                  print(map['name']);
                  print(map['year']);
                  print(map['rating']);
                },
                child: const Text('GET DATA'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var response = await moviesRef.get();
                  dynamic list = response.docs;
                  print(list.first.data());
                  print(list[2].data());
                },
                child: const Text('GET QUERYSNAPSHOT'),
              ),
              Center(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: babaRef.snapshots(),
                    builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      return Text(
                        '${asyncSnapshot.data?.data()}',
                        style:
                            TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  ),
              */
              StreamBuilder<QuerySnapshot>(
                stream: moviesRef.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Bir Hata Oluştu, Tekrar Deneyiniz'));
                  } else {
                    if (snapshot.hasData) {
                      final listOfDocumentSnap = snapshot.data?.docs;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: listOfDocumentSnap?.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(
                                  '${listOfDocumentSnap?[index]['name']}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${listOfDocumentSnap?[index]['rating']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    await listOfDocumentSnap?[index]
                                        .reference
                                        .delete();
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                child: Form(
                    child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration:
                          InputDecoration(hintText: 'Film Adını Giriniz'),
                    ),
                    TextFormField(
                      controller: ratingController,
                      decoration: InputDecoration(hintText: 'Rating Giriniz'),
                    )
                  ],
                )),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            Map<String, dynamic> movieData = {
              'name': nameController.text,
              'rating': ratingController.text,
            };
            await moviesRef.doc(nameController.text).set(movieData);
            // await moviesRef.doc(nameController.text).update({'rating': '3.1'});
          },
        ),
      ),
    );
  }
}
