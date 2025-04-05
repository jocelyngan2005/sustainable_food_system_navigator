import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class DetectionService {
  static Future<Map<String, dynamic>> analyzeImage(File imageFile) async {

    // Simulated Cloud Vision API call (replace with actual API)
    try {
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('http://10.0.2.2:5000/detect')
      );
      
      var pic = await http.MultipartFile.fromPath('file', imageFile.path);
      request.files.add(pic);

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var result = String.fromCharCodes(responseData);

      print("Raw response: $result");

      try {
        final jsonResult = json.decode(result);
        if (jsonResult['labels'] != null) {
          return {
          'diagnosis': jsonResult['labels']
              .map((label) =>
                  '${label['description']} (${(label['score'] * 100).toStringAsFixed(1)}%)')
              .join(', '),
          };
        } else {
          throw Exception('Unexpected response format.');
        }
      } catch (e) {
        print('Disease detection error: $e');
        throw Exception('Error detecting disease or pest.');
      }
    } catch (e) {
      print('Disease detection error: $e');
      throw Exception('Error detecting disease or pest.');
    }
  
  }
}