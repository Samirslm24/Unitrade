import 'package:flutter/material.dart';

class Item {
  final String name;
  final String price;
  final String image;
  final String category;
  final String seller;
  final String description;

  Item({
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.seller,
    required this.description,
  });
}

//  THEME CONSTANTS

class AppColors {
  static const primary = Color(0xFF1A1A2E);
  static const accent = Color(0xFF00C9A7);
  static const surface = Color(0xFFF5F5F0);
  static const card = Colors.white;
  static const textDark = Color(0xFF1A1A2E);
  static const textMuted = Color(0xFF8A8A9A);
  static const danger = Color(0xFFFF5C5C);
}

//  HOME PAGE (shell with bottom nav)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;

  final List<Item> _items = [
    Item(
      name: "Calculus Textbook",
      price: "1500",
      image: "assets/book.jpg",
      category: "Books",
      seller: "Abebe T.",
      description: "Stewart Calculus 8th edition, barely used.",
    ),
    Item(
      name: "Desk Lamp",
      price: "800",
      image: "assets/lamp.jpg",
      category: "Gear",
      seller: "Meron A.",
      description: "LED lamp with adjustable brightness.",
    ),
    Item(
      name: "Ruler Set",
      price: "400",
      image: "assets/ruler_set.jpg",
      category: "Gear",
      seller: "Dawit K.",
      description: "30cm + 15cm rulers, triangle set included.",
    ),
    Item(
      name: "Small Shelf",
      price: "2000",
      image: "assets/small_shelf.jpg",
      category: "Furniture",
      seller: "Sara H.",
      description: "3-tier wooden shelf, easy to assemble.",
    ),
  ];

  void _addItem(Item item) => setState(() => _items.add(item));

  @override
  Widget build(BuildContext context) {
    final screens = [
      MarketScreen(
        items: _items,
        onItemTap: (item) => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
        ),
      ),
      SellScreen(onPost: (item) {
        _addItem(item);
        setState(() => _currentTab = 0);
      }),
      ProfileScreen(itemCount: _items.length),
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: screens[_currentTab],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.storefront_rounded, "Market"),
              _navItem(1, Icons.add_circle_rounded, "Sell"),
              _navItem(2, Icons.person_rounded, "Profile"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final selected = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: selected ? AppColors.accent : AppColors.textMuted,
                size: 22),
            if (selected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

//  MARKET SCREEN

class MarketScreen extends StatefulWidget {
  final List<Item> items;
  final void Function(Item) onItemTap;

  const MarketScreen({super.key, required this.items, required this.onItemTap});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String _selectedCategory = "All";
  String _searchQuery = "";
  final List<String> _categories = ["All", "Books", "Gear", "Furniture"];

  List<Item> get _filtered => widget.items.where((item) {
        final matchCat =
            _selectedCategory == "All" || item.category == _selectedCategory;
        final matchSearch =
            item.name.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchCat && matchSearch;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildSearch(),
          _buildCategories(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: AppColors.accent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              const Text(
                "UNITRADE",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Student\nMarketplace",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: "Search items...",
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColors.textMuted),
          filled: true,
          fillColor: AppColors.card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final selected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList() {
    if (_filtered.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 56, color: AppColors.textMuted),
            SizedBox(height: 12),
            Text("No items found",
                style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      itemCount: _filtered.length,
      itemBuilder: (_, i) => _ItemCard(
        item: _filtered[i],
        onTap: () => widget.onItemTap(_filtered[i]),
      ),
    );
  }
}

//  Item Card Widget

class _ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const _ItemCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item.image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 70,
                    height: 70,
                    color: AppColors.surface,
                    child: const Icon(Icons.image_rounded,
                        color: AppColors.textMuted, size: 28),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.textDark,
                        )),
                    const SizedBox(height: 3),
                    Text(item.category,
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(item.seller,
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${item.price} Birr",
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textMuted, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  ITEM DETAIL SCREEN

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textDark),
        ),
        title: const Text(
          "Item Detail",
          style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
              fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                item.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.image_rounded,
                      color: AppColors.textMuted, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(item.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      )),
                ),
                Text("${item.price} Birr",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                    )),
              ],
            ),
            const SizedBox(height: 6),
            Text(item.category,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 16),
            Text(item.description,
                style: const TextStyle(
                    color: AppColors.textDark, fontSize: 15, height: 1.5)),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    item.seller[0],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Text(item.seller,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Contacting ${item.seller}..."),
                    backgroundColor: AppColors.accent,
                  ));
                },
                child: const Text("Contact Seller",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  SELL SCREEN with form validation

class SellScreen extends StatefulWidget {
  final void Function(Item) onPost;

  const SellScreen({super.key, required this.onPost});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedCategory = "Books";
  final List<String> _categories = ["Books", "Gear", "Furniture"];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onPost(Item(
      name: _nameCtrl.text.trim(),
      price: _priceCtrl.text.trim(),
      image: "assets/placeholder.jpg",
      category: _selectedCategory,
      seller: "You",
      description: _descCtrl.text.trim(),
    ));
    _nameCtrl.clear();
    _priceCtrl.clear();
    _descCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Listing posted!"),
      backgroundColor: AppColors.accent,
    ));
  }

  InputDecoration _fieldDecor(String label, IconData icon) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.accent, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.danger, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.danger, width: 2)),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: AppColors.accent, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  const Text("NEW LISTING",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accent,
                        letterSpacing: 3,
                      )),
                ],
              ),
              const SizedBox(height: 4),
              const Text("Sell an Item",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  )),
              const SizedBox(height: 24),

              // Item Name
              TextFormField(
                controller: _nameCtrl,
                decoration: _fieldDecor("Item Name", Icons.label_rounded),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Name is required";
                  if (v.trim().length < 3) return "Name is too short";
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Price
              TextFormField(
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                decoration: _fieldDecor("Price (Birr)", Icons.payments_rounded),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Price is required";
                  }
                  final n = num.tryParse(v.trim());
                  if (n == null) return "Enter a valid number";
                  if (n <= 0) return "Price must be greater than 0";
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Category
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: _fieldDecor("Category", Icons.category_rounded),
                dropdownColor: AppColors.card,
                items: _categories
                    .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
                validator: (v) => v == null ? "Select a category" : null,
              ),
              const SizedBox(height: 14),

              // Description
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                decoration: _fieldDecor("Description", Icons.notes_rounded),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Description is required";
                  }
                  if (v.trim().length < 10) {
                    return "Please write at least 10 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: _submit,
                  child: const Text("Post Listing",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  PROFILE SCREEN

class ProfileScreen extends StatelessWidget {
  final int itemCount;

  const ProfileScreen({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: AppColors.accent, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                const Text("MY ACCOUNT",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                      letterSpacing: 3,
                    )),
              ],
            ),
            const SizedBox(height: 4),
            const Text("Profile",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                )),
            const SizedBox(height: 28),

            // Avatar card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary,
                    child: Text("S",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800)),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Student User",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: AppColors.textDark,
                          )),
                      SizedBox(height: 4),
                      Text("student@college.edu",
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stats
            Row(
              children: [
                _statCard("$itemCount", "Listings"),
                const SizedBox(width: 12),
                _statCard("0", "Sold"),
                const SizedBox(width: 12),
                _statCard("4.9★", "Rating"),
              ],
            ),
            const SizedBox(height: 24),

            _menuTile(Icons.list_alt_rounded, "My Listings", context),
            _menuTile(Icons.history_rounded, "Purchase History", context),
            _menuTile(Icons.settings_rounded, "Settings", context),
            _menuTile(Icons.logout_rounded, "Log Out", context,
                color: AppColors.danger),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: AppColors.textDark,
                )),
            const SizedBox(height: 2),
            Text(label,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(IconData icon, String label, BuildContext context,
      {Color color = AppColors.textDark}) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$label tapped"),
        duration: const Duration(seconds: 1),
      )),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: color, fontSize: 14)),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
