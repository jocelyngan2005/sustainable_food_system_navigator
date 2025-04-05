import 'package:flutter/material.dart';
import '../services/crop_yield_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/advice_widget.dart';

class CropYieldScreen extends StatefulWidget {
  @override
  _CropYieldScreenState createState() => _CropYieldScreenState();
}

class _CropYieldScreenState extends State<CropYieldScreen>{
  final _formKey = GlobalKey<FormState>();

   // Service for API calls
  final CropYieldService _yieldService = CropYieldService();
  
  // Dropdown lists
  final List<String> _areaList = [
    'Albania', 'Algeria', 'Angola', 'Argentina', 'Armenia',
       'Australia', 'Austria', 'Azerbaijan', 'Bahamas', 'Bahrain',
       'Bangladesh', 'Belarus', 'Belgium', 'Botswana', 'Brazil',
       'Bulgaria', 'Burkina Faso', 'Burundi', 'Cameroon', 'Canada',
       'Central African Republic', 'Chile', 'Colombia', 'Croatia',
       'Denmark', 'Dominican Republic', 'Ecuador', 'Egypt', 'El Salvador',
       'Eritrea', 'Estonia', 'Finland', 'France', 'Germany', 'Ghana',
       'Greece', 'Guatemala', 'Guinea', 'Guyana', 'Haiti', 'Honduras',
       'Hungary', 'India', 'Indonesia', 'Iraq', 'Ireland', 'Italy',
       'Jamaica', 'Japan', 'Kazakhstan', 'Kenya', 'Latvia', 'Lebanon',
       'Lesotho', 'Libya', 'Lithuania', 'Madagascar', 'Malawi',
       'Malaysia', 'Mali', 'Mauritania', 'Mauritius', 'Mexico',
       'Montenegro', 'Morocco', 'Mozambique', 'Namibia', 'Nepal',
       'Netherlands', 'New Zealand', 'Nicaragua', 'Niger', 'Norway',
       'Pakistan', 'Papua New Guinea', 'Peru', 'Poland', 'Portugal',
       'Qatar', 'Romania', 'Rwanda', 'Saudi Arabia', 'Senegal',
       'Slovenia', 'South Africa', 'Spain', 'Sri Lanka', 'Sudan',
       'Suriname', 'Sweden', 'Switzerland', 'Tajikistan', 'Thailand',
       'Tunisia', 'Turkey', 'Uganda', 'Ukraine', 'United Kingdom',
       'Uruguay', 'Zambia', 'Zimbabwe'
  ];

  final List<String> _itemList = [
    'Maize', 'Potatoes', 'Rice, paddy', 'Sorghum', 'Soybeans', 'Wheat',
       'Cassava', 'Sweet potatoes', 'Plantains and others', 'Yams'
  ];

  // Dropdown selected values
  String? _selectedArea;
  String? _selectedItem;
  
  // Other controllers
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _rainfallController = TextEditingController();
  final TextEditingController _pesticideController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();

  String? _predictionResult;
  // Prediction result and loading state
  double? _predictedYield;
  bool _isLoadingResult = false;
  bool _isLoadingAdvice = false;
  String? _errorMessage;
  String? _advice = null;

  @override
  void initState() {
    super.initState();
    // Check API health on init
    _checkApiHealth();
    //loadRelevantLabels(); 
  }

  Future<void> _checkApiHealth() async {
    final isHealthy = await _yieldService.checkApiHealth();
    if (!isHealthy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backend service is unavailable'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _predictCropYield() async {
    // Validate inputs
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }
    // Set loading state
    setState(() {
      _isLoadingResult = true;
      _isLoadingAdvice = true; // Set Gemini loading state
      _errorMessage = null;
      _predictedYield = null;
      _predictionResult = null;
      _advice = ""; // Reset advice
    });

    print('Starting prediction...');

    // Simulated yield prediction (replace with actual ML model endpoint)
    try {
      // Call prediction service
      final prediction = await _yieldService.predictCropYield(
        area: _selectedArea!,
        item: _selectedItem!,
        year: int.parse(_yearController.text),
        rainfall: double.parse(_rainfallController.text),
        pesticides: double.parse(_pesticideController.text),
        avgTemp: double.parse(_temperatureController.text),
      );
      print('Prediction successful: ${prediction.cropYield}');

      // Update UI with prediction
      setState(() {
        _predictedYield = prediction.cropYield;
        _predictionResult = 'Predicted Yield: ${prediction.cropYield.toStringAsFixed(2)} hg/ha';
        _isLoadingResult = false;
      });

      // Fetch expert advice
      await _getGeminiAdvice(
        area: _selectedArea!,
        item: _selectedItem!,
        year: _yearController.text,
        rainfall: _rainfallController.text,
        pesticides: _pesticideController.text,
        avgTemp: _temperatureController.text,
        predictedYield: prediction.cropYield.toStringAsFixed(2),
      );

    } catch (e) {
      // Handle errors
        print('Error during prediction: $e');
        setState(() {
          _errorMessage = e.toString();
          _isLoadingResult = false;
          _isLoadingAdvice = false; 
      });

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage ?? 'Prediction failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

Future<void> _getGeminiAdvice({
  required String area,
    required String item,
    required String year,
    required String rainfall,
    required String pesticides,
    required String avgTemp,
    required String predictedYield,
}) async{
  final String geminiApiKey = "YOUR_GEMINI_API_KEY"; // Replace with your API key
    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=$geminiApiKey";

    final requestPayload = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": "Provide expert farming advice for the following inputs:\nArea: $area\nCrop: $item\nYear: $year\nAverage Rainfall: $rainfall mm/year\nPesticides: $pesticides tonnes\nAverage Temperature: $avgTemp °C\nPredicted Yield: $predictedYield hg/ha"}
          ]
        }
      ]
    };

    print('Request payload: ${jsonEncode(requestPayload)}'); // Debugging

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestPayload),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _advice = data["candidates"][0]["content"]["parts"][0]["text"] ?? "No advice available.";
          _isLoadingAdvice = false; // Set loading state to false after fetching advice
        });
      } else {
        print('Error fetching advice: ${response.statusCode} - ${response.body}');
        setState(() {
          _advice = "Error fetching advice: ${response.statusCode}";
        });
      }
    } catch (e) {
      print('Error fetching advice: $e');
      setState(() {
        _advice = "Error fetching advice.";
      });
    }
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Yield Prediction', style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: const Color(0xFF5F8F58),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to the desired color
        ),
      ),
      body: Container(color: const Color(0xFFFCF3DD),child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Crop Yield Prediction Section
              const Text(
                'Crop Yield Prediction',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // Area Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Country/Area',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color:Color(0xFF5F8F58), width: 2), 
                  ),
                  labelStyle: const TextStyle(color:  Color(0xFF5F8F58)),
                ),
                value: _selectedArea,
                hint: const Text('Select Country', style: TextStyle(color: Color(0xFF5F8F58))),
                items: _areaList
                    .map((area) => DropdownMenuItem(
                          value: area,
                          child: Text(area),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedArea = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Item Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Crop Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5F8F58), width: 2), 
                  ),
                  labelStyle: const TextStyle(color:  Color(0xFF5F8F58)),
                ),
                value: _selectedItem,
                hint: const Text('Select Crop', style: TextStyle(color: Color(0xFF5F8F58))),
                items: _itemList
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a crop type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Year Input
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5F8F58), width: 2), 
                  ),
                  labelStyle: const TextStyle(color: Color(0xFF5F8F58)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter year';
                  }
                  int? year = int.tryParse(value);
                  if (year == null || year < 2000 || year > DateTime.now().year) {
                    return 'Enter a valid year';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Rainfall Input
              TextFormField(
                controller: _rainfallController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Average Rainfall (mm/year)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color:  Color(0xFF5F8F58), width: 2), 
                  ),
                  labelStyle: const TextStyle(color:  Color(0xFF5F8F58)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter average rainfall';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Pesticide Input
              TextFormField(
                controller: _pesticideController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Pesticides (tonnes)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color:  Color(0xFF5F8F58), width: 2), 
                  ),
                  labelStyle: const TextStyle(color:  Color(0xFF5F8F58)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pesticide usage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Temperature Input
              TextFormField(
                controller: _temperatureController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Average Temperature (°C)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5F8F58), width: 2), 
                  ),
                  labelStyle: const TextStyle(color:  Color(0xFF5F8F58)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter average temperature';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Prediction Button
              ElevatedButton(
                onPressed: _predictCropYield,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5F8F58),
                ),
                child: const Text(
                  'Predict Crop Yield',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              // Loading Indicator for Prediction
              if (_isLoadingResult)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),

              // Results Display
              if (_predictionResult != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.insights,
                          size: 40,
                          color: Colors.green[800],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Prediction Result',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                       const SizedBox(height: 10),
                        Text(
                          _predictionResult!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),

                // Loading Indicator for Advice
                if (_isLoadingAdvice)
                  const Column(
                  children: [
                    Text(
                    'Loading expert advice, please wait...',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 10),
                    Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                    ),
                  ],
                  ),

                // Expert Advice Section
                if (!_isLoadingAdvice && _advice != null)
                  AdviceWidget(advice: _advice!)
                else if (!_isLoadingAdvice && _advice == null)
                  Text(
                    'No advice available.',
                    style: TextStyle(fontSize: 16, color: Colors.green[900]),
                  ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
