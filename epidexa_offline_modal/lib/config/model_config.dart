class ModelConfig {
  static const int inputImageWidth = 224;
  static const int inputImageHeight = 224;
  static const int numChannels = 3;
  static const int numClasses = 23;

  static const List<String> diseaseClasses = [
    'Acne and Rosacea Photos',
    'Actinic Keratosis Basal Cell Carcinoma and other Malignant Lesions',
    'Atopic Dermatitis Photos',
    'Bullous Disease Photos',
    'Cellulitis Impetigo and other Bacterial Infections',
    'Eczema Photos',
    'Exanthems and Drug Eruptions',
    'Hair Loss Photos Alopecia and other Hair Diseases',
    'Herpes HPV and other STDs Photos',
    'Light Diseases and Disorders of Pigmentation',
    'Lupus and other Connective Tissue diseases',
    'Melanoma Skin Cancer Nevi and Moles',
    'Nail Fungus and other Nail Disease',
    'Poison Ivy Photos and other Contact Dermatitis',
    'Psoriasis pictures Lichen Planus and related diseases',
    'Scabies Lyme Disease and other Infestations and Bites',
    'Seborrheic Keratoses and other Benign Tumors',
    'Systemic Disease',
    'Tinea Ringworm Candidiasis and other Fungal Infections',
    'Urticaria Hives',
    'Vascular Tumors',
    'Vasculitis Photos',
    'Warts Molluscum and other Viral Infections',
  ];

  static const String huggingFaceModel = 'WahajRaza/finetuned-dermnet';
  static const double confidenceThreshold = 0.5;
  static const String tfliteModelPath =
      'assets/models/skin_disease_model.tflite';
  static const String labelsPath = 'assets/models/labels.txt';
}
