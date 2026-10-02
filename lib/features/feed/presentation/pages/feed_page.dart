import 'package:flutter/material.dart';
import '../../data/models/item_model.dart';
import '../../data/repositories/feed_repository.dart';
import '../widgets/item_card.dart';
import '../widgets/search_bar_widget.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final FeedRepository _repository = FeedRepository();
  
  List<ItemModel> _allItems = [];
  String _searchQuery = '';
  String _selectedCategory = 'ทั้งหมด';
  String _selectedStatus = 'ทั้งหมด';

  final List<String> _categories = [
    'ทั้งหมด',
    'ไอที/อิเล็กทรอนิกส์',
    'กระเป๋า/เป้',
    'เอกสาร/บัตร',
    'กุญแจ',
    'อื่นๆ'
  ];

  @override
  void initState() {
    super.initState();
    _allItems = _repository.fetchItems();
  }

  List<ItemModel> get _filteredItems {
    return _allItems.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.locationName.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'ทั้งหมด' || item.category == _selectedCategory;
      final matchesStatus = _selectedStatus == 'ทั้งหมด' || item.status == _selectedStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found Tracker'),
        elevation: 0,
      ),
      body: Column(
        children: [
          SearchBarWidget(
            query: _searchQuery,
            onChanged: (val) => setState(() => _searchQuery = val),
            onClear: () => setState(() => _searchQuery = ''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildStatusChip('ทั้งหมด', 'ทั้งหมด'),
                const SizedBox(width: 8),
                _buildStatusChip('ของหาย', 'LOST'),
                const SizedBox(width: 8),
                _buildStatusChip('เจอของแล้ว', 'FOUND'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat),
                    selected: _selectedCategory == cat,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 24),
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(child: Text('ไม่พบรายการที่คุณค้นหา'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      return ItemCard(
                        item: _filteredItems[index],
                        onTap: () {},
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedStatus == value,
      onSelected: (selected) {
        if (selected) setState(() => _selectedStatus = value);
      },
    );
  }
}