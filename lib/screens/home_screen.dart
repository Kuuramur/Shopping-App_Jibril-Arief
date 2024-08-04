import 'package:e_commerce/providers/service_providers.dart';
import 'package:e_commerce/screens/favorite_screen.dart';
import 'package:e_commerce/screens/product_detail_screen.dart';
import 'package:e_commerce/screens/shopping_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ServiceProviders serviceProviders = ServiceProviders();

  @override
  void initState() {
    Provider.of<ServiceProviders>(context, listen: false).fetchProduct();
    Provider.of<ServiceProviders>(context, listen: false).fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Product"),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ServiceProviders>(context, listen: false)
                  .fetchProduct();
            },
            icon: const Icon(Icons.restart_alt_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<ServiceProviders>(context, listen: false)
            .fetchProduct(),
        child: Consumer<ServiceProviders>(
          builder: (context, value, child) {
            // handle error
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (value.errorMessage != null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Error"),
                      content: Text(value.errorMessage.toString()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            serviceProviders.clearErrorMessage();
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              }
            });

            if (value.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                if (value.user != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Welcome, ${value.user!.name}!',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButton<String>(
                    value: value.selectedCategory,
                    hint: const Text('Select Category'),
                    onChanged: (String? newValue) {
                      Provider.of<ServiceProviders>(context, listen: false)
                          .setSelectedCategory(newValue);
                    },
                    items: <String>[
                      'All',
                      'Clothes',
                      'Electronics',
                      'Shoes',
                      'Furniture',
                      'Others'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    children: List.generate(
                      value.filteredProducts.length,
                      (index) {
                        final product = value.filteredProducts[index];
                        final imageUrl = product.images![0].toString();
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
                                      icon: Icon(
                                        value.favoriteItems.contains(product)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: value.favoriteItems
                                                .contains(product)
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                      onPressed: () {
                                        Provider.of<ServiceProviders>(context,
                                                listen: false)
                                            .toggleFavorite(product.id!);
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      color: Colors.black.withOpacity(0.6),
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title ?? 'No title',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            '\$${product.price ?? '0'}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShoppingCartScreen()),
          );
        },
        child: Stack(
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: Icon(Icons.shopping_cart, size: 28),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Consumer<ServiceProviders>(
                builder: (context, value, child) {
                  return CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      value.cartItems.length.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
