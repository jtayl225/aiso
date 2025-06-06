import 'package:aiso/constants/string_constants.dart';
import 'package:flutter/material.dart';

class AgentFormScreen extends StatefulWidget {
  const AgentFormScreen({super.key});

  @override
  State<AgentFormScreen> createState() => _AgentFormScreenState();
}

class _AgentFormScreenState extends State<AgentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Country and state maps
  final Map<String, String> countriesMap = {
    'Australia': 'AUS',
    // 'New Zealand': 'NZL',
    // 'United States': 'USA',
  };

  final Map<String, String> australianStatesMap = {
    'Victoria': 'VIC',
    'New South Wales': 'NSW',
    'Queensland': 'QLD',
    'Western Australia': 'WA',
    'South Australia': 'SA',
    'Tasmania': 'TAS',
    'Northern Territory': 'NT',
    'Australian Capital Territory': 'ACT',
  };

  // Form state
  String firstName = '';
  String lastName = '';
  String email = '';
  String? countryIso = 'AUS'; // stored ISO value
  String? stateCode;  // stored short code
  String postcode = '';
  String agencyName = '';

  bool get isFormValid {
    return true &&
        // firstName.isNotEmpty &&
        // lastName.isNotEmpty &&
        email.isNotEmpty &&
        countryIso != null &&
        (countryIso != 'AUS' || stateCode != null) &&
        postcode.isNotEmpty &&
        agencyName.isNotEmpty;
  }

  void _updateField(String value, void Function(String) updateFn) {
    setState(() {
      updateFn(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generate Free Report!")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        logoImage,
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // _buildTextField("First Name", (val) => _updateField(val, (v) => firstName = v)),
                    // _buildTextField("Last Name", (val) => _updateField(val, (v) => lastName = v)),
                    _buildTextField("Email", (val) => _updateField(val, (v) => email = v), keyboardType: TextInputType.emailAddress),
                    _buildTextField("Real Estate Agency Name", (val) => _updateField(val, (v) => agencyName = v)),
                    _buildDropdownField(
                      label: "Country",
                      value: countryIso,
                      items: countriesMap.entries.map((e) => MapEntry(e.value, e.key)).toList(),
                      onChanged: (val) {
                        _updateField(val!, (v) => countryIso = v);
                        // Reset state if country changes
                        if (val != 'AUS') {
                          stateCode = null;
                        }
                      },
                    ),
                    if (countryIso == 'AUS')
                      _buildDropdownField(
                        label: "State",
                        value: stateCode,
                        items: australianStatesMap.entries.map((e) => MapEntry(e.value, e.key)).toList(),
                        onChanged: (val) => _updateField(val!, (v) => stateCode = v),
                      ),
                    _buildTextField("Postcode", (val) => _updateField(val, (v) => postcode = v), keyboardType: TextInputType.number),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: isFormValid
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            print("Generating report...");
                            print("Country ISO: $countryIso");
                            print("State Code: $stateCode");
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text("Generate free report!"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<MapEntry<String, String>> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items
            .map((entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                ))
            .toList(),
        onChanged: onChanged,
        validator: (val) {
          if (val == null || val.isEmpty) return 'Required';
          return null;
        },
      ),
    );
  }
}
