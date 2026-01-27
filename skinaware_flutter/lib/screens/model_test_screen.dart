// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../services/pytorch_inference_service.dart';

// class ModelTestScreen extends StatefulWidget {
//   const ModelTestScreen({Key? key}) : super(key: key);

//   @override
//   State<ModelTestScreen> createState() => _ModelTestScreenState();
// }

// class _ModelTestScreenState extends State<ModelTestScreen> {
//   final _pytorchService = PyTorchInferenceService();
//   final _imagePicker = ImagePicker();

//   bool _isInitializing = true;
//   bool _isAnalyzing = false;
//   String? _selectedImagePath;
//   Map<String, dynamic>? _result;
//   List<Map<String, dynamic>>? _topResults;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _initializeModel();
//   }

//   Future<void> _initializeModel() async {
//     setState(() {
//       _isInitializing = true;
//       _error = null;
//     });

//     try {
//       await _pytorchService.initialize();
//       setState(() {
//         _isInitializing = false;
//       });
//       _showSnackBar('✓ Model loaded successfully', Colors.green);
//     } catch (e) {
//       setState(() {
//         _isInitializing = false;
//         _error = 'Failed to load model: $e';
//       });
//       _showSnackBar('Error loading model: $e', Colors.red);
//     }
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: source,
//         maxWidth: 1024,
//         maxHeight: 1024,
//         imageQuality: 85,
//       );

//       if (image != null) {
//         setState(() {
//           _selectedImagePath = image.path;
//           _result = null;
//           _topResults = null;
//           _error = null;
//         });

//         // Auto analyze after picking
//         await _analyzeImage();
//       }
//     } catch (e) {
//       _showSnackBar('Error picking image: $e', Colors.red);
//     }
//   }

//   Future<void> _analyzeImage() async {
//     if (_selectedImagePath == null) {
//       _showSnackBar('Please select an image first', Colors.orange);
//       return;
//     }

//     setState(() {
//       _isAnalyzing = true;
//       _error = null;
//     });

//     try {
//       // Get single prediction
//       final result = await _pytorchService.predict(_selectedImagePath!);

//       // Get top 3 predictions
//       final topResults = await _pytorchService.predictTopK(
//         _selectedImagePath!,
//         k: 3,
//       );

//       setState(() {
//         _result = result;
//         _topResults = topResults;
//         _isAnalyzing = false;
//       });

//       _showSnackBar('✓ Analysis complete', Colors.green);
//     } catch (e) {
//       setState(() {
//         _isAnalyzing = false;
//         _error = 'Analysis failed: $e';
//       });
//       _showSnackBar('Error: $e', Colors.red);
//     }
//   }

//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _pytorchService.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Model Test'),
//         backgroundColor: Colors.teal,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _isInitializing ? null : _initializeModel,
//             tooltip: 'Reload Model',
//           ),
//         ],
//       ),
//       body: _isInitializing
//           ? _buildLoadingView()
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   _buildImageSection(),
//                   const SizedBox(height: 16),
//                   _buildActionButtons(),
//                   const SizedBox(height: 24),
//                   if (_isAnalyzing) _buildAnalyzingView(),
//                   if (_error != null) _buildErrorView(),
//                   if (_result != null) _buildResultsView(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildLoadingView() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(),
//           SizedBox(height: 16),
//           Text('Loading PyTorch model...'),
//           SizedBox(height: 8),
//           Text(
//             'This may take a few seconds',
//             style: TextStyle(color: Colors.grey, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImageSection() {
//     return Card(
//       elevation: 4,
//       child: Container(
//         height: 300,
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: _selectedImagePath != null
//             ? ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.file(
//                   File(_selectedImagePath!),
//                   fit: BoxFit.contain,
//                 ),
//               )
//             : const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.image, size: 64, color: Colors.grey),
//                     SizedBox(height: 8),
//                     Text(
//                       'No image selected',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: _isAnalyzing
//                 ? null
//                 : () => _pickImage(ImageSource.gallery),
//             icon: const Icon(Icons.photo_library),
//             label: const Text('Gallery'),
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               backgroundColor: Colors.teal,
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: _isAnalyzing
//                 ? null
//                 : () => _pickImage(ImageSource.camera),
//             icon: const Icon(Icons.camera_alt),
//             label: const Text('Camera'),
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               backgroundColor: Colors.teal,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAnalyzingView() {
//     return const Card(
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Row(
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(width: 16),
//             Text('Analyzing image...'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorView() {
//     return Card(
//       color: Colors.red[50],
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             const Icon(Icons.error, color: Colors.red),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 _error!,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResultsView() {
//     final confidence = (_result!['confidence'] as double) * 100;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Card(
//           color: Colors.green[50],
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Top Prediction',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   _result!['diseaseClass'],
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.teal,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Text('Confidence: '),
//                     Text(
//                       '${confidence.toStringAsFixed(2)}%',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: confidence > 70 ? Colors.green : Colors.orange,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 LinearProgressIndicator(
//                   value: confidence / 100,
//                   backgroundColor: Colors.grey[300],
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     confidence > 70 ? Colors.green : Colors.orange,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         if (_topResults != null && _topResults!.isNotEmpty) ...[
//           const Text(
//             'Top 3 Predictions',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           ..._topResults!.asMap().entries.map((entry) {
//             final index = entry.key;
//             final result = entry.value;
//             final conf = (result['confidence'] as double) * 100;

//             return Card(
//               margin: const EdgeInsets.only(bottom: 8),
//               child: ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: index == 0 ? Colors.teal : Colors.grey,
//                   child: Text('${index + 1}'),
//                 ),
//                 title: Text(
//                   result['class'],
//                   style: const TextStyle(fontSize: 14),
//                 ),
//                 trailing: Text(
//                   '${conf.toStringAsFixed(1)}%',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: conf > 50 ? Colors.green : Colors.grey,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ],
//       ],
//     );
//   }
// }
