import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/harga_jual_barang_item.dart';
import '../viewmodels/harga_jual_barang_viewmodel.dart';
import '../widget/reusablecode.dart';
import '../viewmodels/calculator_viewmodel.dart';
import 'calculator_view.dart';

/// Widget tampilan untuk daftar barang.
class HargaJualBarangView extends StatelessWidget {
  const HargaJualBarangView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HargaJualBarangViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }

          // **Tambahkan WillPopScope di sini**
          return PopScope(
            canPop: !viewModel.showSearchBox,
            onPopInvoked: (didPop) {
              if (didPop) {
                return;
              }
              viewModel.toggleSearchBox();
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  forceElevated: true,
                  backgroundColor: Colors.white,
                  title: _buildAppBarTitle(context, viewModel),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(kTextTabBarHeight),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.blueGrey[700],
                      child: viewModel.showSearchBox
                          ? _buildSearchBar(context, viewModel)
                          : _buildTableHeader(),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var item = viewModel.filteredAndSortedItems[index];
                      return _buildItemSlidable(context, item, index, viewModel);
                    },
                    childCount: viewModel.filteredAndSortedItems.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFABActions(context);
        },
        child: const Icon(Icons.menu),
      ),
    );
  }

  // Semua metode lainnya tetap sama
  void _showFABActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Tambah Barang'),
                onTap: () {
                  Navigator.pop(bc);
                  _showAddDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calculate),
                title: const Text('Kalkulator'),
                onTap: () {
                  Navigator.pop(bc);
                  _showCalculatorModal(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showCalculatorModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const CalculatorView();
      },
    );
  }

  Widget _buildAppBarTitle(BuildContext context, HargaJualBarangViewModel viewModel) {
    List<String> displayKategoriList = ['Semua Kategori', ...viewModel.categories];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: DropdownButtonHideUnderline(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: viewModel.selectedKategori,
                hint: const Text('Pilih Kategori'),
                isDense: true,
                items: displayKategoriList.map<DropdownMenuItem<String>>((String kategori) {
                  return DropdownMenuItem<String>(
                    value: kategori,
                    child: Text(kategori),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  viewModel.updateSelectedKategori(newValue);
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _showAddCategoryDialog(context),
          icon: const Icon(Icons.category),
        ),
        IconButton(
          onPressed: () {
            viewModel.toggleSearchBox();
          },
          icon: Icon(viewModel.showSearchBox ? Icons.close : Icons.search),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, HargaJualBarangViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: viewModel.searchController,
        focusNode: viewModel.searchFocusNode,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Cari barang...',
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          suffixIcon: viewModel.searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    viewModel.searchController.clear();
                    viewModel.notifyListeners();
                    FocusScope.of(context).requestFocus(viewModel.searchFocusNode);
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(50.0),
        1: FlexColumnWidth(1.0),
        2: FlexColumnWidth(1.0),
        3: FlexColumnWidth(1.0),
      },
      border: TableBorder.all(
        color: Colors.blueGrey[800]!,
        width: 0.5,
      ),
      children: [
        TableRow(
          children: [
            _tableHeaderCell("No"),
            _tableHeaderCell("Nama\nBarang"),
            _tableHeaderCell("Harga\nJual/pcs"),
            _tableHeaderCell("Harga\nJual/pak"),
          ],
        ),
      ],
    );
  }

  Widget _tableHeaderCell(String text) {
    return TableCell(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Text(text, style: fontbold.copyWith(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildItemSlidable(BuildContext context, Item item, int index, HargaJualBarangViewModel viewModel) {
    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _showDeleteConfirmationDialog(context, viewModel, item.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            spacing: 8,
          ),
          SlidableAction(
            onPressed: (context) => _showUpdateDialog(context, item),
            backgroundColor: Colors.yellow[800]!,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          ),
          SlidableAction(
            onPressed: null,
            backgroundColor: Colors.blue[700]!,
            foregroundColor: Colors.white,
            label: 'Modal: ${item.modal}',
            spacing: 8,
          )
        ],
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(50.0),
          1: FlexColumnWidth(1.0),
          2: FlexColumnWidth(1.0),
          3: FlexColumnWidth(1.0),
        },
        border: const TableBorder(
          top: BorderSide(width: 0.5, color: Colors.grey),
        ),
        children: [
          TableRow(
            children: [
              _tableCell((index + 1).toString()),
              _tableCell(item.name),
              _tableCell(item.hargapcs),
              _tableCell(item.hargapak),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableCell(String text) {
    return TableCell(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Text(text),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, HargaJualBarangViewModel viewModel, String? id) {
    if (id == null) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ya'),
              onPressed: () {
                viewModel.deleteItem(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    var nameController = TextEditingController();
    var hargapcsController = TextEditingController();
    var hargapakController = TextEditingController();
    var modalController = TextEditingController();
    final viewModel = Provider.of<HargaJualBarangViewModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        String? _currentSelectedKategori = viewModel.selectedKategori != 'Semua Kategori'
            ? viewModel.selectedKategori
            : null;
        return StatefulBuilder(
          builder: (context, setState) {
            bool isFormValid = nameController.text.isNotEmpty &&
                hargapcsController.text.isNotEmpty &&
                hargapakController.text.isNotEmpty &&
                modalController.text.isNotEmpty &&
                _currentSelectedKategori != null;
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: Text('Tambah Barang', style: TextStyle(fontSize: 20))),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nama Barang'),
                        onChanged: (value) => setState(() {}),
                      ),
                      TextField(
                        controller: hargapcsController,
                        decoration: const InputDecoration(labelText: 'Harga Barang / pcs'),
                        onChanged: (value) => setState(() {}),
                      ),
                      TextField(
                        controller: hargapakController,
                        decoration: const InputDecoration(labelText: 'Harga Barang / pak'),
                        onChanged: (value) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      if (viewModel.categories.isNotEmpty)
                        DropdownButtonFormField<String>(
                          value: _currentSelectedKategori,
                          items: viewModel.categories.map((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentSelectedKategori = newValue;
                            });
                          },
                          decoration: const InputDecoration(labelText: 'Kategori'),
                        )
                      else
                        const Text('Tidak ada kategori. Tambahkan kategori terlebih dahulu.', style: TextStyle(fontStyle: FontStyle.italic)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: modalController,
                        decoration: const InputDecoration(labelText: 'Harga Modal'),
                        onChanged: (value) => setState(() {}),
                      ),
                      ElevatedButton(
                        onPressed: isFormValid ? () {
                          var newItem = Item(
                            id: '',
                            name: nameController.text.trim(),
                            hargapcs: hargapcsController.text.trim(),
                            hargapak: hargapakController.text.trim(),
                            kategori: _currentSelectedKategori!,
                            modal: modalController.text.trim(),
                          );
                          viewModel.addItem(newItem);
                          Navigator.of(context).pop();
                        } : null,
                        child: const Text('Simpan'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, Item item) {
    var nameController = TextEditingController(text: item.name);
    var hargapcsController = TextEditingController(text: item.hargapcs);
    var hargapakController = TextEditingController(text: item.hargapak);
    var modalController = TextEditingController(text: item.modal);
    String _currentSelectedKategori = item.kategori ?? '';

    showDialog(context: context, builder: (context) {
      return Consumer<HargaJualBarangViewModel>(
        builder: (context, viewModel, child) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: Text('Update Barang', style: TextStyle(fontSize: 20))),
                    const SizedBox(height: 20),
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama Barang')),
                    TextField(controller: hargapcsController, decoration: const InputDecoration(labelText: 'Harga Barang / pcs')),
                    TextField(controller: hargapakController, decoration: const InputDecoration(labelText: 'Harga Barang / pak')),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _currentSelectedKategori.isNotEmpty ? _currentSelectedKategori : null,
                      items: viewModel.categories.map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _currentSelectedKategori = newValue;
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Kategori'),
                    ),
                    const SizedBox(height: 10),
                    TextField(controller: modalController, decoration: const InputDecoration(labelText: 'Harga Modal')),
                    ElevatedButton(
                      onPressed: () {
                        var updatedItem = Item(
                          id: item.id,
                          name: nameController.text.trim(),
                          hargapcs: hargapcsController.text.trim(),
                          hargapak: hargapakController.text.trim(),
                          kategori: _currentSelectedKategori,
                          modal: modalController.text.trim(),
                        );
                        viewModel.updateItem(item.id, updatedItem);
                        Navigator.pop(context);
                      },
                      child: const Text('Update Data'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  void _showAddCategoryDialog(BuildContext context) {
    var categoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Tambah Kategori Baru', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Kategori',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    Consumer<HargaJualBarangViewModel>(
                      builder: (context, viewModel, child) {
                        return ElevatedButton(
                          onPressed: () {
                            var name = categoryController.text.trim();
                            if (name.isNotEmpty) {
                              viewModel.addCategory(name);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Simpan'),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}