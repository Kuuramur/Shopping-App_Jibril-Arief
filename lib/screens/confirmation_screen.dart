import 'package:e_commerce/providers/service_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider

class ConfirmationPage extends StatelessWidget {
  final String transactionId;
  final String userName;
  final String userEmail;
  final double totalPayment;
  final DateTime transactionDate;

  const ConfirmationPage({
    super.key,
    required this.transactionId,
    required this.userName,
    required this.userEmail,
    required this.totalPayment,
    required this.transactionDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction ID: $transactionId',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Name: $userName', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Email: $userEmail', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Total Payment: \$${totalPayment.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Date: ${transactionDate.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
                'Time: ${transactionDate.toLocal().toString().split(' ')[1].split('.')[0]}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text(
              'Successful Payment',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Access the ServiceProviders instance and reset it
                  Provider.of<ServiceProviders>(context, listen: false).reset();

                  // Navigate back to the home page
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
