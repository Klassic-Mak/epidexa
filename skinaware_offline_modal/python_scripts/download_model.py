#!/usr/bin/env python3
"""
Download pre-trained skin disease detection model from HuggingFace
Model: WahajRaza/finetuned-dermnet
"""

import os
import json
from transformers import AutoImageProcessor, AutoModelForImageClassification
from PIL import Image
import torch

MODEL_NAME = "WahajRaza/finetuned-dermnet"
OUTPUT_DIR = "../models/huggingface_model"

def download_model():
    print("=" * 60)
    print("Downloading WahajRaza/finetuned-dermnet Model")
    print("=" * 60)
    
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    print(f"Downloading model: {MODEL_NAME}")
    
    processor = AutoImageProcessor.from_pretrained(MODEL_NAME)
    model = AutoModelForImageClassification.from_pretrained(MODEL_NAME)
    
    processor.save_pretrained(OUTPUT_DIR)
    model.save_pretrained(OUTPUT_DIR)
    
    print(f"Model downloaded successfully to {OUTPUT_DIR}")
    
    print("\nModel configuration:")
    print(f"- Number of labels: {model.config.num_labels}")
    print(f"- Model type: {model.config.model_type}")
    
    labels = list(model.config.id2label.values())
    labels_file = os.path.join(OUTPUT_DIR, "labels.json")
    with open(labels_file, 'w') as f:
        json.dump(labels, f, indent=2)
    print(f"- Labels saved to: {labels_file}")
    
    print("\nTesting model...")
    test_image = Image.new('RGB', (224, 224), color='white')
    inputs = processor(images=test_image, return_tensors="pt")
    
    with torch.no_grad():
        outputs = model(**inputs)
        logits = outputs.logits
        predicted_class_idx = logits.argmax(-1).item()
    
    print("Test prediction successful!")
    print(f"Predicted class index: {predicted_class_idx}")
    print(f"Predicted class: {model.config.id2label[predicted_class_idx]}")
    
    print("\n✓ Model download and test completed successfully!")

if __name__ == "__main__":
    download_model()
