import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/providers/service_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? 'Product Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display product image
            Image.network(product.images![0]),
            const SizedBox(height: 10),
            // Display product title
            Text(
              product.title ?? 'No Title',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            // Display product price
            Text(
              'Price: \$${product.price}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            // Display product description
            Text(
              product.description ?? 'No Description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add product to the cart
                  Provider.of<ServiceProviders>(context, listen: false)
                      .addToCart(product);
                  // Show a snackbar message that the product has been added to the cart
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart')),
                  );
                },
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
