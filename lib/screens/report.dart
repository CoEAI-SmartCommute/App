import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F6),
      appBar: AppBar(
        title: const Text(
          'Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffEEEEEE),
                border: InputBorder.none,
                hintText: 'Choose Destination',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Describe the unsafe situation',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const TextField(
              minLines: 8,
              maxLines: 10,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffEEEEEE),
                border: InputBorder.none,
                hintText: 'Type your inputs...',
              ),
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 48,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll(
                    Color(0xffEBEBEB),
                  ),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  elevation: const MaterialStatePropertyAll(0),
                ),
                onPressed: () {},
                child: const Text('Upload Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
