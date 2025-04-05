import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/detection_service.dart';
import '../widgets/result_card.dart';
import '../widgets/advice_widget.dart';

class DiagnosisScreen extends StatefulWidget {
  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> with SingleTickerProviderStateMixin {
  // Separate variables for Disease Detection
  File? _diseaseImageFile;
  String? _diseaseDiagnosisResult;
  String _diseaseAdvice = "";

  // Separate variables for Pest Detection
  File? _pestImageFile;
  String? _pestDiagnosisResult;
  String _pestAdvice = "";

  bool _isLoadingDisease = false;
  bool _isLoadingPest = false;
  bool _isLoadingAdvice = false;

  final picker = ImagePicker();
  final String geminiApiKey = "YOUR_GEMINI_API_KEY"; // Replace with your actual API key

  List<String> pestLabels = [];
  List<String> diseaseLabels = [];

  // Future<void> loadRelevantLabels() async {
  //   final String response = await rootBundle.loadString('assets/pest_labels.json');
  //   pestLabels = List<String>.from(json.decode(response));
  //   final String response2 = await rootBundle.loadString('assets/disease_labels.json');
  //   diseaseLabels = List<String>.from(json.decode(response2));
  // }

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Two tabs: Disease and Pest
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    setState(() {
      if (pickedFile != null) {
        if (type == 'Disease') {
          _diseaseImageFile = File(pickedFile.path);
        } else if (type == 'Pest') {
          _pestImageFile = File(pickedFile.path);
        }
      }
    });
  }

  Future<void> _analyzeImage(String type) async {
    File? imageFile;
    if (type == 'Disease') {
      imageFile = _diseaseImageFile;
      setState(() {
      _isLoadingDisease = true; // Start loading for disease detection
    });
    } else if (type == 'Pest') {
      imageFile = _pestImageFile;
      setState(() {
      _isLoadingPest = true; // Start loading for pest detection
    });
    }

    if (imageFile == null) return;

    try {
      final result = await DetectionService.analyzeImage(imageFile);
      // Update the UI with the detection result
      setState(() {
        if (type == 'Disease') {
          _diseaseDiagnosisResult = result['diagnosis'];
        } else if (type == 'Pest') {
          _pestDiagnosisResult = result['diagnosis'];
        }
      });
      // Fetch advice based on the diagnosis
      print('Calling _getGeminiAdvice'); // Debugging
      await _getGeminiAdvice(type, result['diagnosis']);
    } catch (e) {
      setState(() {
        if (type == 'Disease') {
          _diseaseDiagnosisResult = 'Error detecting Disease.';
        } else if (type == 'Pest') {
          _pestDiagnosisResult = 'Error detecting Pest.';
        }
      });
    } finally {
    setState(() {
      if (type == 'Disease') {
        _isLoadingDisease = false; // Stop loading for disease detection
      } else if (type == 'Pest') {
        _isLoadingPest = false; // Stop loading for pest detection
      }
    });
  }
  }
  
  Future<void> _getGeminiAdvice(String type, String detectedIssues) async {
    // Call your Gemini API here and update the `_advice` variable
    // This function is not part of the service and should remain in the widget
    setState(() {
      _isLoadingAdvice = true; // Start loading for advice
    });
    final url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=$geminiApiKey";

    final requestPayload = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": "Provide expert farming advice for the following detected $type issues: $detectedIssues"}
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (type == 'Disease') {
            _diseaseAdvice = data["candidates"][0]["content"]["parts"][0]["text"] ?? "No advice available.";
          } else if (type == 'Pest') {
            _pestAdvice = data["candidates"][0]["content"]["parts"][0]["text"] ?? "No advice available.";
          }
        });
      } else {
        print('Error fetching advice: ${response.statusCode} - ${response.body}');
        setState(() {
          if (type == 'Disease') {
            _diseaseAdvice = "Error fetching advice: ${response.statusCode}";
          } else if (type == 'Pest') {
            _pestAdvice = "Error fetching advice: ${response.statusCode}";
          }
        });
      }
    } catch (e) {
      print('Error fetching advice: $e');
      setState(() {
        if (type == 'Disease') {
          _diseaseAdvice = "Error fetching advice.";
        } else if (type == 'Pest') {
          _pestAdvice = "Error fetching advice.";
        }
      });
    } finally {
      setState(() {
        _isLoadingAdvice = false; // Stop loading for advice
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return
      Scaffold(
        appBar: AppBar(
          title: const Text(
            'Disease and Pest Detection',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF5F8F58),
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to the desired color
          ),
          bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white, // Change this to the desired color
          indicatorWeight: 4.0,
          tabs: const[
            Tab(icon: Icon(Icons.health_and_safety, color: Colors.white), child: Text('Disease Detection', style: TextStyle(color: Colors.white))),
            Tab(icon: Icon(Icons.bug_report, color: Colors.white), child: Text('Pest Detection', style: TextStyle(color: Colors.white))),
          ],
          
        ),
        ),
        body: TabBarView(
        controller: _tabController,
        children: [
          // Disease Detection Tab
          _buildDetectionTab('Disease'),

          // Pest Detection Tab
          _buildDetectionTab('Pest'),
        ],
      ),
    );
  }


Widget _buildDetectionTab(String type){
  final imageFile = type == 'Disease' ? _diseaseImageFile : _pestImageFile;
  final diagnosisResult = type == 'Disease' ? _diseaseDiagnosisResult : _pestDiagnosisResult;
  final advice = type == 'Disease' ? _diseaseAdvice : _pestAdvice;

  return Container(color: const Color(0xFFFCF3DD),child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$type Detection',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:  Color(0xFF5F8F58),
                ),
              ),
              const SizedBox(height: 10),

              // Image Picker Button
              ElevatedButton.icon(
                onPressed: () => _pickImage(type),
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text(
                  'Upload Image',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5F8F58),
                ),
              ),
              const SizedBox(height: 10),

              // Display Selected Image
              if (imageFile != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.file(
                    imageFile,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 10),

              // Disease and Pest Detection Button
              ElevatedButton(
                onPressed: () => _analyzeImage(type),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5F8F58),
                ),
                child: Text(
                  'Detect $type',
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              // if (_isLoadingDisease && type == 'Disease' || _isLoadingPest && type == 'Pest')
              //       const Center(
              //         child: Padding(
              //           padding: EdgeInsets.all(16.0),
              //           child: CircularProgressIndicator(),
              //         ),
              //       ),

              // Disease Detection Result
              if(diagnosisResult != null)
                ResultCard(
                  title: 'Detection Result',
                  content: diagnosisResult,
                ),

              const Divider(),
              // Advice Display
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
                  )
              else if (advice.isNotEmpty)
                AdviceWidget(advice: advice)
              else
                Text(
                  'No advice available.',
                  style: TextStyle(fontSize: 16, color: Colors.green[900]),
                ),
            ]
          )
        )
      ),
    );

}
}