import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/providers/service_providers.dart';
import 'package:e_commerce/screens/confirmation_screen.dart';
import 'package:e_commerce/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  // Memperbarui lokasi saat ini menggunakan Geolocator
  Future<void> _updateCurrentLocation() async {
    final serviceProvider =
        Provider.of<ServiceProviders>(context, listen: false);
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // Mendapatkan nama lokasi dari koordinat dan menyimpannya ke penyedia layanan
    String location = await serviceProvider.getLocationName(
        position.latitude, position.longitude);
    serviceProvider.setDeliveryLocation(location);
  }

  @override
  void initState() {
    super.initState();
    // Memperbarui lokasi saat inisialisasi
    _updateCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<ServiceProviders>(
        builder: (context, serviceProvider, child) {
          // Mendapatkan item keranjang dari penyedia layanan
          final cartItems = serviceProvider.cartItems;

          // Menampilkan pesan jika keranjang kosong
          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          // Menghitung total pesanan dan pembayaran
          double totalOrder = cartItems.fold(
              0, (sum, item) => sum + (item.product.price! * item.quantity));
          const double serviceFee = 2.0;
          double totalPayment = totalOrder + serviceFee;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return ListTile(
                      // Menampilkan gambar produk menggunakan CachedNetworkImage
                      leading: CachedNetworkImage(
                        imageUrl: item.product.images![0],
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      // Menampilkan judul dan kuantitas produk
                      title: Text(item.product.title ?? 'No title'),
                      subtitle: Text(
                          'Quantity: ${item.quantity} \nPrice: \$${item.product.price}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              // Mengurangi kuantitas item di keranjang
                              serviceProvider.updateCartItemQuantity(
                                  item.product, item.quantity - 1);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              // Menambah kuantitas item di keranjang
                              serviceProvider.updateCartItemQuantity(
                                  item.product, item.quantity + 1);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Order Summary'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Menampilkan ringkasan pesanan dan lokasi pengiriman
                          Text(
                              'Total Order: \$${totalOrder.toStringAsFixed(2)}'),
                          const SizedBox(height: 4.0),
                          Text(
                              'Service Fee: \$${serviceFee.toStringAsFixed(2)}'),
                          const SizedBox(height: 4.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Delivery Location: ${serviceProvider.deliveryLocation}'),
                              if (serviceProvider.deliveryLocationNote !=
                                      null &&
                                  serviceProvider
                                      .deliveryLocationNote!.isNotEmpty)
                                Text(
                                  'Note: ${serviceProvider.deliveryLocationNote}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ElevatedButton(
                                onPressed: () async {
                                  // Membuka layar lokasi untuk mengedit lokasi pengiriman
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LocationScreen()),
                                  );

                                  // Memperbarui lokasi pengiriman jika ada hasil dari layar lokasi
                                  if (result != null) {
                                    String city = result['city'];
                                    String? note = result['note'];
                                    serviceProvider.setDeliveryLocation(city,
                                        note: note);
                                  }
                                },
                                child: const Text('Edit Location'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text('Total Payment'),
                      trailing: Text('\$${totalPayment.toStringAsFixed(2)}'),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        // Mengenerate ID transaksi menggunakan UUID
                        final transactionId = const Uuid().v4();
                        final user = serviceProvider.user;
                        final dateTime = DateTime.now();
                        // Membuka halaman konfirmasi pembayaran
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmationPage(
                              transactionId: transactionId,
                              userName: user?.name ?? 'Anonymous',
                              userEmail: user?.email ?? 'anonymous@example.com',
                              totalPayment: totalPayment,
                              transactionDate: dateTime,
                            ),
                          ),
                        );
                      },
                      child: const Text('Payment'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
