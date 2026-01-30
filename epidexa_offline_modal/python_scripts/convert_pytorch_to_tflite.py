#!/usr/bin/env python3
"""
Convert PyTorch ViT model to TFLite format via ONNX
This is a multi-step process:
1. PyTorch -> ONNX
2. ONNX -> TensorFlow SavedModel
3. TensorFlow SavedModel -> TFLite
"""

import os
import json
import torch
import numpy as np
from transformers import AutoImageProcessor, AutoModelForImageClassification
import onnx
from onnx_tf.backend import prepare

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)
MODEL_DIR = os.path.join(PROJECT_DIR, "models", "huggingface_model")
ONNX_PATH = os.path.join(PROJECT_DIR, "models", "model.onnx")
TF_MODEL_DIR = os.path.join(PROJECT_DIR, "models", "tf_model")
TFLITE_PATH = os.path.join(PROJECT_DIR, "models", "skin_disease_model.tflite")
LABELS_PATH = os.path.join(PROJECT_DIR, "models", "labels.txt")

def check_dependencies():
    """Check if required packages are installed."""
    try:
        import onnx
        import onnx_tf
        import tensorflow as tf
        print("✓ All required packages are installed")
        return True
    except ImportError as e:
        print(f"\n❌ Missing required package: {e}")
        print("\nPlease install required packages:")
        print("  pip install onnx onnx-tf tensorflow")
        return False

def export_to_onnx():
    """Export PyTorch model to ONNX format."""
    print("\n" + "=" * 60)
    print("Step 1: Exporting PyTorch model to ONNX")
    print("=" * 60)
    
    print(f"Loading PyTorch model from {MODEL_DIR}...")
    processor = AutoImageProcessor.from_pretrained(MODEL_DIR)
    model = AutoModelForImageClassification.from_pretrained(MODEL_DIR)
    model.eval()
    
    # Create dummy input
    dummy_input = torch.randn(1, 3, 224, 224)
    
    print(f"Exporting to ONNX: {ONNX_PATH}")
    torch.onnx.export(
        model,
        dummy_input,
        ONNX_PATH,
        export_params=True,
        opset_version=12,
        do_constant_folding=True,
        input_names=['input'],
        output_names=['output'],
        dynamic_axes={
            'input': {0: 'batch_size'},
            'output': {0: 'batch_size'}
        }
    )
    
    print(f"✓ ONNX model saved to {ONNX_PATH}")
    
    # Verify ONNX model
    onnx_model = onnx.load(ONNX_PATH)
    onnx.checker.check_model(onnx_model)
    print("✓ ONNX model verified")
    
    return True

def convert_onnx_to_tensorflow():
    """Convert ONNX model to TensorFlow SavedModel."""
    print("\n" + "=" * 60)
    print("Step 2: Converting ONNX to TensorFlow SavedModel")
    print("=" * 60)
    
    print(f"Loading ONNX model from {ONNX_PATH}...")
    onnx_model = onnx.load(ONNX_PATH)
    
    print(f"Converting to TensorFlow SavedModel: {TF_MODEL_DIR}")
    tf_rep = prepare(onnx_model)
    tf_rep.export_graph(TF_MODEL_DIR)
    
    print(f"✓ TensorFlow SavedModel saved to {TF_MODEL_DIR}")
    return True

def convert_tensorflow_to_tflite():
    """Convert TensorFlow SavedModel to TFLite."""
    print("\n" + "=" * 60)
    print("Step 3: Converting TensorFlow to TFLite")
    print("=" * 60)
    
    import tensorflow as tf
    
    print(f"Loading TensorFlow model from {TF_MODEL_DIR}...")
    converter = tf.lite.TFLiteConverter.from_saved_model(TF_MODEL_DIR)
    
    # Optimization settings
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.target_spec.supported_types = [tf.float16]
    
    print("Converting to TFLite format...")
    tflite_model = converter.convert()
    
    print(f"Saving TFLite model to {TFLITE_PATH}...")
    with open(TFLITE_PATH, 'wb') as f:
        f.write(tflite_model)
    
    file_size = os.path.getsize(TFLITE_PATH) / (1024 * 1024)
    print(f"✓ TFLite model saved: {TFLITE_PATH} ({file_size:.2f} MB)")
    
    return True

def create_labels_file():
    """Create labels.txt file for TFLite model."""
    print("\n" + "=" * 60)
    print("Creating labels file")
    print("=" * 60)
    
    labels_json = os.path.join(MODEL_DIR, "labels.json")
    with open(labels_json, 'r') as f:
        labels = json.load(f)
    
    with open(LABELS_PATH, 'w') as f:
        for label in labels:
            f.write(f"{label}\n")
    
    print(f"✓ Labels file created: {LABELS_PATH}")
    print(f"  Total classes: {len(labels)}")

def main():
    print("=" * 60)
    print("PyTorch to TFLite Conversion")
    print("=" * 60)
    
    if not check_dependencies():
        print("\n⚠️  Please install missing dependencies and try again")
        return False
    
    try:
        # Step 1: PyTorch -> ONNX
        if not export_to_onnx():
            return False
        
        # Step 2: ONNX -> TensorFlow
        if not convert_onnx_to_tensorflow():
            return False
        
        # Step 3: TensorFlow -> TFLite
        if not convert_tensorflow_to_tflite():
            return False
        
        # Create labels file
        create_labels_file()
        
        print("\n" + "=" * 60)
        print("✓ CONVERSION COMPLETED SUCCESSFULLY!")
        print("=" * 60)
        print(f"\nTFLite model: {TFLITE_PATH}")
        print(f"Labels file: {LABELS_PATH}")
        print("\nNext steps:")
        print("1. Test with Dart: fvm flutter pub get && dart test/test_tflite_model.dart")
        print("2. Copy to Flutter assets if accuracy is good")
        
        return True
        
    except Exception as e:
        print(f"\n❌ Error during conversion: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)
