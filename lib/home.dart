import 'package:flutter/material.dart';
import 'package:sql_proj/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DataBaseHelper myDB = DataBaseHelper();

  List<Map> items = [];

  int _selectedId = 0;
  String _selectedName = '';
  int _selectedAge = 0;

  @override
  void initState() {
    myDB.init().then((value) => _fetchData());
    super.initState();
  }

  void _fetchData() async {
    List<Map> results = await myDB.fecth();
    print(results);
    setState(() {
      items = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 80, right: 20, left: 20, bottom: 80),
            child: Center(
              child: Container(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showInsertDialog(context);
                      },
                      child: Text('Insert'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: _select,
                      child: Text('Select'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showUpdateDialog(context);
                      },
                      child: Text('Update'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDeleteDialog(context);
                      },
                      child: Text('Delete'),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Header of the table
                    const Card(
                      color: Colors.deepPurple,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'ID',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'Age',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    items.isNotEmpty
                        ? FutureBuilder(
                            future: myDB.fecth(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                List<Map> data = snapshot.data ?? <Map>[];
                                return Container(
                                  height: 200,
                                  child: ListView.builder(
                                    shrinkWrap:
                                        true, // Important to prevent scrolling issues inside ListView
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      Map item = data[
                                          index]; // Iterate through the data
                                      return GestureDetector(
                                        onTap: () {
                                          //Update the selected record
                                          _selectedId = item['_id'];
                                          _selectedName = item['_name'];
                                          _selectedAge = item['_age'];

                                          //Here the user must click the Update Button
                                        },
                                        child: Card(
                                          color: Colors.grey,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      item['_id'].toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: Text(
                                                      item['_name'],
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      item['_age'].toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          )
                        : const Text('There is no data to show here'),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showInsertDialog(BuildContext context) {
    TextEditingController qName = TextEditingController();
    TextEditingController qAge = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Insert'),
          content: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Name'),
                TextFormField(
                  controller: qName,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text('Age'),
                TextFormField(
                  controller: qAge,
                  obscureText: false,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                //Insertion code
                _insert(qName.text, int.parse(qAge.text));

                //After insertion close the dialog
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void showUpdateDialog(BuildContext context) {
    TextEditingController qName = TextEditingController();
    TextEditingController qAge = TextEditingController();

    qName.text = _selectedName;
    qAge.text = _selectedAge.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Name'),
                TextFormField(
                  controller: qName,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text('Age'),
                TextFormField(
                  controller: qAge,
                  obscureText: false,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                //Insertion code
                _update(_selectedId, qName.text, int.parse(qAge.text));

                //After insertion close the dialog
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure you want to delete this record?'),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    const Text(
                      'Name: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_selectedName),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Age: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_selectedAge.toString()),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                //Insertion code
                _delete(_selectedId);

                //After insertion close the dialog
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _insert(String name, int age) async {
    myDB.insert(name, age);
  }

  void _select() {}

  void _update(int id, String name, int age) {
    setState(() {
      myDB.update(id, name, age);
    });
  }

  void _delete(int id) {
    setState(() {
      myDB.delete(id);
    });
  }
}
