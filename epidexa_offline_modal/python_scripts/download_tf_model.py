#!/usr/bin/env python3
"""
Download TensorFlow version of the model and convert to TFLite.
This is much simpler than PyTorch -> ONNX -> TF -> TFLite conversion.
"""

import os
import json
import tensorflow as tf
from transformers import TFAutoModelForImageClassification, AutoImageProcessor

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)
PYTORCH_MODEL_DIR = os.path.join(PROJECT_DIR, "models", "huggingface_model")
TF_MODEL_DIR = os.path.join(PROJECT_DIR, "models", "tf_model")
TFLITE_PATH = os.path.join(PROJECT_DIR, "models", "skin_disease_model.tflite")
LABELS_PATH = os.path.join(PROJECT_DIR, "models", "labels.txt")

def download_and_convert():
    """Load local PyTorch model and convert to TFLite via TensorFlow."""
    print("=" * 60)
    print("Convert PyTorch Model to TFLite")
    print("=" * 60)
    
    # Step 1: Load local PyTorch model
    print(f"\nStep 1: Loading PyTorch model from local directory...")
    print(f"Model path: {PYTORCH_MODEL_DIR}")
    
    try:
        # Load PyTorch model from local directory
        from transformers import AutoModelForImageClassification
        import torch
        
        pt_model = AutoModelForImageClassification.from_pretrained(PYTORCH_MODEL_DIR)
        processor = AutoImageProcessor.from_pretrained(PYTORCH_MODEL_DIR)
        
        print(f"✓ PyTorch model loaded")
        print(f"  Number of classes: {pt_model.config.num_labels}")
        
        # Convert to TensorFlow
        print(f"\nStep 2: Converting PyTorch to TensorFlow...")
        
        # Save PyTorch model config and weights temporarily
        temp_dir = os.path.join(PROJECT_DIR, "models", "temp_pt")
        os.makedirs(temp_dir, exist_ok=True)
        pt_model.save_pretrained(temp_dir)
        processor.save_pretrained(temp_dir)
        
        # Load as TensorFlow model
        model = TFAutoModelForImageClassification.from_pretrained(
            temp_dir,
            from_pt=True
        )
        
        print(f"✓ Model converted to TensorFlow")
        print(f"  Model type: {type(model)}")
        
        # Clean up temp directory
        import shutil
        shutil.rmtree(temp_dir)
        
    except Exception as e:
        print(f"❌ Error during conversion: {e}")
        import traceback
        traceback.print_exc()
        return False
    
    # Step 3: Convert to TFLite directly from Keras model
    print(f"\nStep 3: Converting TensorFlow model to TFLite...")
    
    # Create a concrete function for conversion
    @tf.function(input_signature=[tf.TensorSpec(shape=[None, 224, 224, 3], dtype=tf.float32)])
    def serving_fn(pixel_values):
        return model(pixel_values=pixel_values, training=False)
    
    concrete_func = serving_fn.get_concrete_function()
    converter = tf.lite.TFLiteConverter.from_concrete_functions([concrete_func])
    
    # Optimization settings
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.target_spec.supported_types = [tf.float16]
    
    try:
        tflite_model = converter.convert()
        
        with open(TFLITE_PATH, 'wb') as f:
            f.write(tflite_model)
        
        file_size = os.path.getsize(TFLITE_PATH) / (1024 * 1024)
        print(f"✓ TFLite model saved: {TFLITE_PATH}")
        print(f"  File size: {file_size:.2f} MB")
        
    except Exception as e:
        print(f"❌ TFLite conversion failed: {e}")
        print("\nTrying without optimization...")
        
        # Try without optimization
        converter = tf.lite.TFLiteConverter.from_saved_model(TF_MODEL_DIR)
        tflite_model = converter.convert()
        
        with open(TFLITE_PATH, 'wb') as f:
            f.write(tflite_model)
        
        file_size = os.path.getsize(TFLITE_PATH) / (1024 * 1024)
        print(f"✓ TFLite model saved (no optimization): {TFLITE_PATH}")
        print(f"  File size: {file_size:.2f} MB")
    
    # Step 4: Create labels file
    print(f"\nStep 4: Creating labels file...")
    labels = list(model.config.id2label.values())
    
    with open(LABELS_PATH, 'w') as f:
        for label in labels:
            f.write(f"{label}\n")
    
    print(f"✓ Labels file created: {LABELS_PATH}")
    print(f"  Total classes: {len(labels)}")
    
    print("\n" + "=" * 60)
    print("✓ CONVERSION COMPLETED!")
    print("=" * 60)
    print(f"\nFiles created:")
    print(f"  TFLite model: {TFLITE_PATH}")
    print(f"  Labels file: {LABELS_PATH}")
    print("\nNext steps:")
    print("  1. Create test dataset: python python_scripts/create_test_dataset.py")
    print("  2. Test with Dart: dart test/test_tflite_model.dart")
    
    return True

if __name__ == "__main__":
    try:
        success = download_and_convert()
        exit(0 if success else 1)
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        exit(1)
