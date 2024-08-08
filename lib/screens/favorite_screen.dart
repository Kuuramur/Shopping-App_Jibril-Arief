// Import necessary packages and libraries
import 'package:e_commerce/providers/service_providers.dart';
import 'package:e_commerce/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Stateless widget to display the list of favorite products
class FavoritesScreen extends StatelessWidget {
  // Default constructor
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold to create the basic structure of the page
      appBar: AppBar(
        // AppBar with page title
        title: const Text('Favorites'),
      ),
      // Use Consumer to get data from the ServiceProviders provider
      body: Consumer<ServiceProviders>(
        builder: (context, value, child) {
          // Use ListView.builder to display the list of favorite products
          return ListView.builder(
            // Specify the number of items to display in the list
            itemCount: value.favoriteItems.length,
            // Builder for each item in the list
            itemBuilder: (context, index) {
              // Get the product from the favorites list based on index
              final product = value.favoriteItems[index];
              // Get the product image URL
              final imageUrl = product.images![0].toString();

              return GestureDetector(
                // Event handler when an item in the list is tapped
                onTap: () {
                  // Navigate to ProductDetailScreen when an item is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ),
                  );
                },
                // Display product information in ListTile
                child: ListTile(
                  // Display product image
                  leading: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    // Handle error if image fails to load
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                  // Display product title
                  title: Text(product.title!),
                  // Display product price
                  subtitle: Text('\$${product.price!}'),
                  // Button to remove product from favorites
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.red,
                    onPressed: () {
                      // Remove item from favorites using ServiceProviders
                      Provider.of<ServiceProviders>(context, listen: false)
                          .toggleFavorite(product.id!);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
