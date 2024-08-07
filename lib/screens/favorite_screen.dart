// Import paket dan library yang diperlukan
import 'package:e_commerce/providers/service_providers.dart';
import 'package:e_commerce/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widget Stateless untuk menampilkan daftar produk favorit
class FavoritesScreen extends StatelessWidget {
  // Konstruktor default
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold untuk membuat struktur dasar halaman
      appBar: AppBar(
        // AppBar dengan judul halaman
        title: const Text('Favorites'),
      ),
      // Menggunakan Consumer untuk mendapatkan data dari provider ServiceProviders
      body: Consumer<ServiceProviders>(
        builder: (context, value, child) {
          // Menggunakan ListView.builder untuk menampilkan daftar produk favorit
          return ListView.builder(
            // Menentukan jumlah item yang akan ditampilkan dalam daftar
            itemCount: value.favoriteItems.length,
            // Builder untuk setiap item dalam daftar
            itemBuilder: (context, index) {
              // Mendapatkan produk dari daftar favorit berdasarkan index
              final product = value.favoriteItems[index];
              // Mendapatkan URL gambar produk
              final imageUrl = product.images![0].toString();

              return GestureDetector(
                // Event handler saat item dalam daftar di-tap
                onTap: () {
                  // Menavigasi ke ProductDetailScreen saat item di-klik
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ),
                  );
                },
                // Menampilkan informasi produk dalam ListTile
                child: ListTile(
                  // Menampilkan gambar produk
                  leading: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    // Menangani error jika gambar gagal dimuat
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                  // Menampilkan judul produk
                  title: Text(product.title!),
                  // Menampilkan harga produk
                  subtitle: Text('\$${product.price!}'),
                  // Tombol untuk menghapus produk dari daftar favorit
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.red,
                    onPressed: () {
                      // Menghapus item dari daftar favorit menggunakan ServiceProviders
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
