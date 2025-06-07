import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class PromptHashScreen extends StatefulWidget {
  const PromptHashScreen({super.key});

  @override
  State<PromptHashScreen> createState() => _PromptHashScreenState();
}

class _PromptHashScreenState extends State<PromptHashScreen> {
  String prompt = '';
  String promptHash = '';

  void updateHash(String value) {
    final normalized = value.trim().toLowerCase();
    final bytes = utf8.encode(normalized);
    final digest = sha256.convert(bytes);
    setState(() {
      prompt = value;
      promptHash = digest.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prompt Hash Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Prompt'),
              onChanged: updateHash,
            ),
            SizedBox(height: 20),
            Text(
              'Hash (SHA-256, hex):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText(promptHash),
          ],
        ),
      ),
    );
  }
}
