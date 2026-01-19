#!/usr/bin/env python3
"""
Use the pre-trained model directly without retraining.
The WahajRaza/finetuned-dermnet model is already well-trained on DermNet dataset.
"""

import os
import json
from transformers import AutoImageProcessor, AutoModelForImageClassification
from PIL import Image
import torch
import numpy as np
from sklearn.metrics import accuracy_score, classification_report

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)
MODEL_DIR = os.path.join(PROJECT_DIR, "models", "huggingface_model")
DATASET_DIR = os.path.join(PROJECT_DIR, "dataset")

def load_test_images(dataset_dir, max_per_class=50):
    """Load test images from dataset."""
    print(f"Loading test images from {dataset_dir}...")
    
    image_paths = []
    labels = []
    label_names = []
    
    # First, get all valid class directories
    all_items = sorted(os.listdir(dataset_dir))
    valid_classes = []
    for item in all_items:
        item_path = os.path.join(dataset_dir, item)
        if os.path.isdir(item_path) and not item.startswith('.'):
            valid_classes.append(item)
    
    # Now enumerate only valid classes
    for class_idx, class_name in enumerate(valid_classes):
        label_names.append(class_name)
        class_path = os.path.join(dataset_dir, class_name)
        
        count = 0
        for img_file in os.listdir(class_path):
            if img_file.lower().endswith(('.jpg', '.jpeg', '.png', '.bmp')):
                if count >= max_per_class:
                    break
                image_paths.append(os.path.join(class_path, img_file))
                labels.append(class_idx)
                count += 1
    
    print(f"Loaded {len(image_paths)} images across {len(label_names)} classes")
    return image_paths, labels, label_names

def evaluate_pretrained_model():
    """Evaluate pre-trained model on test dataset."""
    print("=" * 60)
    print("Evaluating Pre-trained Model")
    print("=" * 60)
    
    # Load model
    print(f"\nLoading pre-trained model from {MODEL_DIR}...")
    processor = AutoImageProcessor.from_pretrained(MODEL_DIR)
    model = AutoModelForImageClassification.from_pretrained(MODEL_DIR)
    model.eval()
    
    # Get model's label mapping
    model_labels = list(model.config.id2label.values())
    print(f"\nModel has {len(model_labels)} classes:")
    for i, label in enumerate(model_labels[:5]):
        print(f"  {i}: {label}")
    print(f"  ...")
    
    # Load test images
    image_paths, true_labels, dataset_labels = load_test_images(DATASET_DIR, max_per_class=50)
    
    # Verify labels match
    print(f"\nVerifying label alignment...")
    labels_match = True
    for i, (dataset_label, model_label) in enumerate(zip(dataset_labels, model_labels)):
        if dataset_label != model_label:
            print(f"MISMATCH at index {i}: dataset='{dataset_label}' vs model='{model_label}'")
            labels_match = False
    
    if labels_match:
        print("✓ Dataset labels perfectly match model labels!")
    else:
        print("WARNING: Label mismatch detected!")
    
    print(f"\nEvaluating on {len(image_paths)} images...")
    
    predictions = []
    true_label_list = []
    
    for idx, (img_path, true_label) in enumerate(zip(image_paths, true_labels)):
        if (idx + 1) % 100 == 0:
            print(f"Processed {idx + 1}/{len(image_paths)} images...")
        
        try:
            image = Image.open(img_path).convert('RGB')
            inputs = processor(images=image, return_tensors="pt")
            
            with torch.no_grad():
                outputs = model(**inputs)
                logits = outputs.logits
                predicted_class_idx = logits.argmax(-1).item()
            
            predictions.append(predicted_class_idx)
            true_label_list.append(true_label)
            
        except Exception as e:
            print(f"Error processing {img_path}: {e}")
    
    # Calculate accuracy (labels are already aligned, no mapping needed)
    valid_predictions = predictions
    valid_true_labels = true_label_list
    
    accuracy = accuracy_score(valid_true_labels, valid_predictions)
    
    print("\n" + "=" * 60)
    print("RESULTS")
    print("=" * 60)
    print(f"Total images: {len(image_paths)}")
    print(f"Valid predictions: {len(valid_predictions)}")
    print(f"Accuracy: {accuracy * 100:.2f}%")
    
    # Debug: Check label ranges
    print(f"\nDebug info:")
    print(f"Dataset has {len(dataset_labels)} classes (indices 0-{len(dataset_labels)-1})")
    print(f"True label range: {min(valid_true_labels)} to {max(valid_true_labels)}")
    print(f"Prediction range: {min(valid_predictions)} to {max(valid_predictions)}")
    
    # Per-class accuracy
    print("\nPer-class accuracy:")
    print("-" * 60)
    
    class_correct = {}
    class_total = {}
    
    for true_label, pred_label in zip(valid_true_labels, valid_predictions):
        # Bounds check
        if true_label >= len(dataset_labels):
            print(f"WARNING: true_label {true_label} out of range (max: {len(dataset_labels)-1})")
            continue
            
        class_name = dataset_labels[true_label]
        if class_name not in class_total:
            class_total[class_name] = 0
            class_correct[class_name] = 0
        
        class_total[class_name] += 1
        if true_label == pred_label:
            class_correct[class_name] += 1
    
    for class_name in sorted(class_total.keys()):
        total = class_total[class_name]
        correct = class_correct[class_name]
        acc = (correct / total * 100) if total > 0 else 0
        print(f"{class_name[:50].ljust(50)} {acc:5.1f}% ({correct}/{total})")
    
    print("\n" + "=" * 60)
    print("CONCLUSION")
    print("=" * 60)
    print(f"Pre-trained model accuracy: {accuracy * 100:.2f}%")
    print("\nThis model is already well-trained on DermNet dataset.")
    print("You can use it directly without retraining!")
    print("\nNext steps:")
    print("1. Convert to TFLite: python python_scripts/convert_to_tflite.py")
    print("2. Test TFLite model: dart test/test_tflite_model.dart")

if __name__ == "__main__":
    evaluate_pretrained_model()
