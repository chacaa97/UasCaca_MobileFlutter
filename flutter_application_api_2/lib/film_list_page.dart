import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_manager.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashboardForm(),
    );
  }
}

class DashboardForm extends StatefulWidget {
  const DashboardForm({Key? key}) : super(key: key);

  @override
  _DashboardFormState createState() => _DashboardFormState();
}

class _DashboardFormState extends State<DashboardForm> {
  TextEditingController namaFilmController = TextEditingController();
  TextEditingController deskripsiFilmController = TextEditingController();

  Future<void> _showAddDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Data Film'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: namaFilmController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama Film',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: deskripsiFilmController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Deskripsi Film',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Simpan'),
              onPressed: () async {
                try {
                  String namaFilm = namaFilmController.text;
                  String deskripsiFilm = deskripsiFilmController.text;

                  print("Sebelum memanggil sendFilmData");
                  final apiManager = Provider.of<ApiManager>(context, listen: false);

                  final send = await apiManager.sendFilmData(namaFilm, deskripsiFilm);
                  print("Setelah memanggil sendFilmData");

                  Navigator.pushReplacementNamed(context, '/userList');
                } catch (e) {
                  print("Error $e");
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final apiManager = Provider.of<ApiManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Film'),
        backgroundColor: Colors.blue, // Ganti dengan warna biru yang diinginkan
      ),
      body: Container(
        color: Colors.grey[200],
        child: FutureBuilder<Map<String, dynamic>>(
          future: apiManager.GetFilms(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              Navigator.pushReplacementNamed(context, '/login');
              return Center();
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No data available'),
              );
            } else {
              final jsonResponse = snapshot.data!;
              final data = jsonResponse['film'];

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    final dataFilm = data[index];
                    return Card(
                      child: Column(
                        children: <Widget>[
                          Image.network(
                              'http://128.0.0.1:8000/img/${Uri.encodeFull(dataFilm['judul'])}'),
                          Text('${dataFilm['judul']}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton(
                                child: Text('Edit',
                                    style: TextStyle(color: Colors.blue)),
                                onPressed: () {
                                  TextEditingController namaFilmControllers =
                                      TextEditingController(text: dataFilm['judul']);
                                  TextEditingController deskripsiFilmControllers =
                                      TextEditingController(text: dataFilm['deskripsi']);

                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Ubah Data Film'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              TextField(
                                                controller: namaFilmControllers,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Nama Film',
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextField(
                                                controller: deskripsiFilmControllers,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Deskripsi Film',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Batal'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Simpan'),
                                            onPressed: () async {
                                              try {
                                                String namaFilm = namaFilmControllers.text;
                                                String deskripsiFilm = deskripsiFilmControllers.text;

                                                print("Sebelum memanggil sendFilmData");
                                                final apiManager = Provider.of<ApiManager>(
                                                    context,
                                                    listen: false);

                                                final send = await apiManager.UpdateFilmData(
                                                    namaFilm,
                                                    deskripsiFilm,
                                                    dataFilm['id'].toString());
                                                print("Setelah memanggil sendFilmData");

                                                Navigator.pushReplacementNamed(context, '/userList');
                                              } catch (e) {
                                                print("Error $e");
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              ElevatedButton(
                                child: Text('Hapus',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () async {
                                  try {
                                    final id = dataFilm['id'].toString();
                                    print("Sebelum memanggil sendFilmData");
                                    final apiManager = Provider.of<ApiManager>(
                                        context,
                                        listen: false);

                                    final send = await apiManager.DeleteFilmData(id);
                                    print("Setelah memanggil sendFilmData");

                                    Navigator.pushReplacementNamed(context, '/userList');
                                  } catch (e) {
                                    print("Error $e");
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
