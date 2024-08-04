import 'package:e_commerce/providers/service_providers.dart';
import 'package:e_commerce/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Consumer<ServiceProviders>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.favoriteItems.length,
            itemBuilder: (context, index) {
              final product = value.favoriteItems[index];
              final imageUrl = product.images![0].toString();

              return GestureDetector(
                onTap: () {
                  // Navigate to ProductDetailScreen when the item is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ),
                  );
                },
                child: ListTile(
                  leading: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                  title: Text(product.title!),
                  subtitle: Text('\$${product.price!}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.red,
                    onPressed: () {
                      // Remove item from favorites
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
