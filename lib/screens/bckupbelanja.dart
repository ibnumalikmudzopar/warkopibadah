import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BelanjaScreen extends StatefulWidget {
  BelanjaScreen({Key? key}) : super(key: key);

  @override
  _BelanjaScreenState createState() => _BelanjaScreenState();
}

class _BelanjaScreenState extends State<BelanjaScreen> {
  final List<String> daysOfWeek = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
  bool showForm = false;
  final _formKey = GlobalKey<FormState>();
  String _namaBelanja = '';
  int _jumlah = 0;
  List<Map<String, dynamic>> _belanjaList = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];
  bool _isLoading = false;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<List<String>> fetchSuggestions(String query) async {
    List<String> suggestions = [];
    var snapshot = await FirebaseFirestore.instance
        .collection('barang_items')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .limit(5)
        .get();

    suggestions = snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    return suggestions;
  }

  void _updateSuggestions(String query) async {
    setState(() {
      _isLoading = true;
    });
    final suggestions = await fetchSuggestions(query);
    setState(() {
      _isLoading = false;
      _suggestions = suggestions;
      _showOverlay();
    });
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_suggestions[index]),
                  onTap: () {
                    _controller.text = _suggestions[index];
                    _namaBelanja = _suggestions[index];
                    _removeOverlay();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String monthName = DateFormat.yMMMM().format(now);
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    int startWeekday = firstDayOfMonth.weekday % 7;

    return Scaffold(
      body: showForm
          ? SingleChildScrollView(
              child: _buildForm(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monthName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: daysOfWeek.map((day) => Expanded(
                          child: Center(
                            child: Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        )).toList(),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                      ),
                      itemCount: daysInMonth(now) + startWeekday,
                      itemBuilder: (context, index) {
                        if (index < startWeekday) {
                          return Center(
                            child: Text(''),
                          );
                        }
                        DateTime date = DateTime(now.year, now.month, index - startWeekday + 1);
                        bool isToday = date.day == now.day && date.month == now.month && date.year == now.year;
                        return Center(
                          child: Text(
                            DateFormat.d().format(date),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                              color: isToday ? Colors.red : Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showForm = true;
                        });
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 300,
            width: 500,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Nama Barang')),
                  DataColumn(label: Text('Jumlah')),
                ],
                rows: _belanjaList
                    .map(
                      (belanja) => DataRow(
                        cells: [
                          DataCell(Text(belanja['nama'])),
                          DataCell(Text(belanja['jumlah'].toString())),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _belanjaList.clear();
                  });
                },
                child: Text("Reset"),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Submit to Firebase'),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: _showAddBarangDialog,
                child: Text("Tambah"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showForm = false;
                  });
                },
                child: Text("Kembali"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddBarangDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Belanja'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CompositedTransformTarget(
                  link: _layerLink,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _updateSuggestions(value);
                      } else {
                        _removeOverlay();
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Ketik Nama Barang',
                      suffixIcon: _isLoading ? CircularProgressIndicator() : null,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Jumlah',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter jumlah';
                    }
                    return null;
                  },
                  onSaved: (value) => setState(() => _jumlah = int.parse(value!)),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    _belanjaList.add({'nama': _namaBelanja, 'jumlah': _jumlah});
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, 1);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, 1);
    return firstDayNextMonth.subtract(Duration(days: 1)).day;
  }
}
