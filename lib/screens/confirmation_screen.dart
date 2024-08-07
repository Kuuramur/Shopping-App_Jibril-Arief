// Import paket dan library yang diperlukan
import 'package:e_commerce/providers/service_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider

// Widget Stateless untuk menampilkan halaman konfirmasi pembayaran
class ConfirmationPage extends StatelessWidget {
  // Properti yang dibutuhkan untuk menampilkan informasi transaksi
  final String transactionId;
  final String userName;
  final String userEmail;
  final double totalPayment;
  final DateTime transactionDate;

  // Konstruktor untuk menginisialisasi properti yang dibutuhkan
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
      // Scaffold untuk membuat struktur dasar halaman
      appBar: AppBar(
        // Menampilkan judul pada AppBar
        title: const Text('Payment Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Menampilkan informasi transaksi dalam kolom
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan ID transaksi
            Text('Transaction ID: $transactionId',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            // Menampilkan nama pengguna
            Text('Name: $userName', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            // Menampilkan email pengguna
            Text('Email: $userEmail', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            // Menampilkan total pembayaran
            Text('Total Payment: \$${totalPayment.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            // Menampilkan tanggal transaksi
            Text('Date: ${transactionDate.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            // Menampilkan waktu transaksi
            Text(
                'Time: ${transactionDate.toLocal().toString().split(' ')[1].split('.')[0]}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            // Menampilkan pesan konfirmasi bahwa pembayaran berhasil
            const Text(
              'Successful Payment',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 40),
            Center(
              // Tombol untuk kembali ke halaman utama
              child: ElevatedButton(
                onPressed: () {
                  // Mengakses instance ServiceProviders dan meresetnya
                  Provider.of<ServiceProviders>(context, listen: false).reset();

                  // Menavigasi kembali ke halaman utama
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
