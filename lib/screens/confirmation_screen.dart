// Import necessary packages and libraries
import 'package:e_commerce/providers/service_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider

// Stateless widget to display the payment confirmation page
class ConfirmationPage extends StatelessWidget {
  // Properties needed to display transaction information
  final String transactionId;
  final String userName;
  final String userEmail;
  final double totalPayment;
  final DateTime transactionDate;

  // Constructor to initialize required properties
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
      // Scaffold to create the basic structure of the page
      appBar: AppBar(
        // Display title on the AppBar
        title: const Text('Payment Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Display transaction information in a column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display transaction ID
            Text('Transaction ID: $transactionId',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            // Display user name
            Text('Name: $userName', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            // Display user email
            Text('Email: $userEmail', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            // Display total payment
            Text('Total Payment: \$${totalPayment.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            // Display transaction date
            Text('Date: ${transactionDate.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            // Display transaction time
            Text(
                'Time: ${transactionDate.toLocal().toString().split(' ')[1].split('.')[0]}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            // Display confirmation message indicating successful payment
            const Text(
              'Successful Payment',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 40),
            Center(
              // Button to return to the home page
              child: ElevatedButton(
                onPressed: () {
                  // Access the instance of ServiceProviders and reset it
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
