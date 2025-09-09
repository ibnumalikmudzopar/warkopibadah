// File: lib/viewmodels/harga_jual_barang_viewmodel.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Tambahkan ini
import '../models/harga_jual_barang_item.dart';
import '../repositories/harga_jual_barang_repository.dart';

class HargaJualBarangViewModel with ChangeNotifier {
  final HargaJualBarangRepository _repository;

  StreamSubscription? _itemsSubscription;
  StreamSubscription? _categoriesSubscription;

  // State
  List<Item> _items = [];
  List<String> _categories = [];
  String _selectedKategori = 'Semua Kategori';
  bool _isLoading = false;
  String? _error;
  bool _showSearchBox = false;

  // 1. Tambahkan TextEditingController dan FocusNode
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Getters
  List<Item> get items => _items;
  List<String> get categories => _categories;
  String get selectedKategori => _selectedKategori;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get showSearchBox => _showSearchBox;
  
  // 2. Tambahkan getters untuk controller dan focus node
  TextEditingController get searchController => _searchController;
  FocusNode get searchFocusNode => _searchFocusNode;

  HargaJualBarangViewModel({required HargaJualBarangRepository repository})
      : _repository = repository {
    _setupFirestoreListeners();
    // 3. Tambahkan listener untuk controller, agar dapat memfilter data secara real-time
    _searchController.addListener(() {
      notifyListeners();
    });
  }

  void _setupFirestoreListeners() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _itemsSubscription?.cancel();
    _categoriesSubscription?.cancel();

    _itemsSubscription = _repository.getBarangItems().listen(
      (data) {
        _items = data;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = "Gagal memuat item: $e";
        _isLoading = false;
        notifyListeners();
      },
    );

    _categoriesSubscription = _repository.getCategories().listen(
      (data) {
        _categories = data;
        if (!_categories.contains(_selectedKategori) && _selectedKategori != 'Semua Kategori') {
          _selectedKategori = 'Semua Kategori';
        }
        notifyListeners();
      },
      onError: (e) {
        _error = "Gagal memuat kategori: $e";
        notifyListeners();
      },
    );
  }

  void updateSelectedKategori(String? newValue) {
    if (newValue != null) {
      _selectedKategori = newValue;
      notifyListeners();
      // Logika untuk memunculkan keyboard saat search box ditampilkan
      if (_showSearchBox) {
      _searchFocusNode.requestFocus();
    }
    }
  }

  // 4. Ubah metode ini untuk menggunakan controller dan focus node
  void toggleSearchBox() {
    _showSearchBox = !_showSearchBox;
    if (!_showSearchBox) {
      _searchController.clear();
    } else {
      _searchFocusNode.requestFocus();
    }
    notifyListeners();
  }

  List<Item> get filteredAndSortedItems {
    List<Item> filteredItems = _items;

    if (_selectedKategori != 'Semua Kategori') {
      filteredItems = filteredItems.where((item) => item.kategori == _selectedKategori).toList();
    }

    // 5. Ubah logika filter dari _searchQuery menjadi _searchController.text
    if (_searchController.text.isNotEmpty) {
      filteredItems = filteredItems.where((item) => item.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }

    filteredItems.sort((a, b) => a.name.compareTo(b.name));

    return filteredItems;
  }

  Future<void> addItem(Item item) async {
    await _repository.addItem(item);
  }

  Future<void> updateItem(String id, Item item) async {
    await _repository.updateItem(id, item);
  }

  Future<void> deleteItem(String id) async {
    await _repository.deleteItem(id);
  }

  Future<void> addCategory(String name) async {
    await _repository.addCategory(name);
  }

  @override
  void dispose() {
    _itemsSubscription?.cancel();
    _categoriesSubscription?.cancel();
    // 6. Jangan lupa dispose controller dan focus node
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}