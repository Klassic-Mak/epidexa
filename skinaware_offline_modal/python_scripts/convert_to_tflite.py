#!/usr/bin/env python3
"""
Convert trained model to TensorFlow Lite format for mobile deployment
"""

import os
import json
import tensorflow as tf
import torch
from transformers import AutoImageProcessor, AutoModelForImageClassification
from PIL import Image
import numpy as np

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)
MODEL_DIR = os.path.join(PROJECT_DIR, "models", "huggingface_model")
OUTPUT_DIR = os.path.join(PROJECT_DIR, "models")
TFLITE_MODEL_PATH = os.path.join(OUTPUT_DIR, "skin_disease_model.tflite")
LABELS_PATH = os.path.join(OUTPUT_DIR, "labels.txt")

def convert_to_tflite():
    print("=" * 60)
    print("Converting Model to TFLite Format")
    print("=" * 60)
    
    print(f"Loading model from {MODEL_DIR}...")
    processor = AutoImageProcessor.from_pretrained(MODEL_DIR)
    model = AutoModelForImageClassification.from_pretrained(MODEL_DIR)
    
    print("\nNote: Direct PyTorch to TFLite conversion is complex.")
    print("For production use, consider:")
    print("1. Using TensorFlow/Keras version of the model")
    print("2. Using ONNX as intermediate format")
    print("3. Re-training with TensorFlow")
    
    labels_json = os.path.join(MODEL_DIR, "labels.json")
    if os.path.exists(labels_json):
        with open(labels_json, 'r') as f:
            labels = json.load(f)
        
        print(f"\nCreating labels file...")
        with open(LABELS_PATH, 'w') as f:
            for label in labels:
                f.write(f"{label}\n")
        print(f"Labels file created: {LABELS_PATH}")
        print(f"Total classes: {len(labels)}")
    
    print("\n" + "=" * 60)
    print("IMPORTANT: TFLite Conversion Steps")
    print("=" * 60)
    print("\nFor actual TFLite conversion, you need to:")
    print("1. Export PyTorch model to ONNX:")
    print("   torch.onnx.export(model, dummy_input, 'model.onnx')")
    print("\n2. Convert ONNX to TensorFlow:")
    print("   onnx-tf convert -i model.onnx -o tf_model")
    print("\n3. Convert TensorFlow to TFLite:")
    print("   converter = tf.lite.TFLiteConverter.from_saved_model('tf_model')")
    print("   tflite_model = converter.convert()")
    print("\nOr use a TensorFlow-based model from the start.")
    
    print(f"\n✓ Labels file ready at: {LABELS_PATH}")
    print("For full TFLite conversion, follow the steps above.")

if __name__ == "__main__":
    convert_to_tflite()
