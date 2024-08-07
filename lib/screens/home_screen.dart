// Import necessary packages and dependencies for the e-commerce application.
import 'package:e_commerce/providers/service_providers.dart';
import 'package:e_commerce/screens/favorite_screen.dart';
import 'package:e_commerce/screens/product_detail_screen.dart';
import 'package:e_commerce/screens/shopping_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Define a stateful widget for the home screen of the e-commerce app.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Create an instance of ServiceProviders for managing data and state.
  ServiceProviders serviceProviders = ServiceProviders();

  @override
  void initState() {
    // Fetch initial product and user data when the screen initializes.
    Provider.of<ServiceProviders>(context, listen: false).fetchProduct();
    Provider.of<ServiceProviders>(context, listen: false).fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build the user interface for the home screen.
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Product"),
        actions: [
          // Add a refresh button to reload products.
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
        // Allow pull-to-refresh functionality for reloading products.
        onRefresh: () => Provider.of<ServiceProviders>(context, listen: false)
            .fetchProduct(),
        child: Consumer<ServiceProviders>(
          builder: (context, value, child) {
            // Handle any error messages that occur during data fetching.
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
                            // Clear error message and close the dialog.
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

            // Display a loading indicator while data is being fetched.
            if (value.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Display the main content of the screen.
            return Column(
              children: [
                // Greet the user if user data is available.
                if (value.user != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Welcome, ${value.user!.name}!',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                // Dropdown menu for selecting product categories.
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
                // Display products in a grid view.
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
                            // Navigate to product detail screen on tap.
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
                                  // Display product image.
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
                                  // Favorite icon for adding/removing favorites.
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
                                  // Product title and price overlay.
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
      // Bottom navigation bar with home and favorites tabs.
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
            // Navigate to favorites screen when the favorites tab is tapped.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
            );
          }
        },
      ),
      // Floating action button for navigating to the shopping cart screen.
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
                  // Display the number of items in the shopping cart.
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
