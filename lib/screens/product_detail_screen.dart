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
            // Menampilkan gambar produk
            Image.network(product.images![0]),
            const SizedBox(height: 10),
            // Menampilkan judul produk
            Text(
              product.title ?? 'No Title',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            // Menampilkan harga produk
            Text(
              'Price: \$${product.price}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            // Menampilkan deskripsi produk
            Text(
              product.description ?? 'No Description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Menambahkan produk ke keranjang
                  Provider.of<ServiceProviders>(context, listen: false)
                      .addToCart(product);
                  // Menampilkan pesan snack bar bahwa produk telah ditambahkan ke keranjang
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
