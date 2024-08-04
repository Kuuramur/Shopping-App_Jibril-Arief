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
  Future<void> _updateCurrentLocation() async {
    final serviceProvider =
        Provider.of<ServiceProviders>(context, listen: false);
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    String location = await serviceProvider.getLocationName(
        position.latitude, position.longitude);
    serviceProvider.setDeliveryLocation(location);
  }

  @override
  void initState() {
    super.initState();
    // Update location on initial load
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
          final cartItems = serviceProvider.cartItems;

          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

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
                      leading: CachedNetworkImage(
                        imageUrl: item.product.images![0],
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      title: Text(item.product.title ?? 'No title'),
                      subtitle: Text(
                          'Quantity: ${item.quantity} \nPrice: \$${item.product.price}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              serviceProvider.updateCartItemQuantity(
                                  item.product, item.quantity - 1);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
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
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LocationScreen()),
                                  );

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
                        final transactionId = const Uuid().v4();
                        final user = serviceProvider.user;
                        final dateTime = DateTime.now();
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
