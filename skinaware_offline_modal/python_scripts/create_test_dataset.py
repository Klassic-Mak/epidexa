#!/usr/bin/env python3
"""
Create test dataset directory by copying the 15% test split used during training.
This ensures the Dart test script tests on the exact same images used for evaluation.
"""

import os
import shutil
from sklearn.model_selection import train_test_split

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)
DATASET_DIR = os.path.join(PROJECT_DIR, "dataset")
TEST_DATASET_DIR = os.path.join(PROJECT_DIR, "dataset_test")

def load_dataset(dataset_dir):
    """Load dataset and return image paths and labels."""
    print(f"Loading dataset from {dataset_dir}...")
    
    image_paths = []
    labels = []
    label_names = []
    
    for class_idx, class_name in enumerate(sorted(os.listdir(dataset_dir))):
        class_path = os.path.join(dataset_dir, class_name)
        
        if not os.path.isdir(class_path) or class_name.startswith('.'):
            continue
        
        label_names.append(class_name)
        
        for img_file in os.listdir(class_path):
            if img_file.lower().endswith(('.jpg', '.jpeg', '.png', '.bmp')):
                image_paths.append(os.path.join(class_path, img_file))
                labels.append(class_idx)
    
    print(f"Found {len(image_paths)} images across {len(label_names)} classes")
    return image_paths, labels, label_names

def create_test_dataset():
    """Create test dataset directory with the same 15% split used in training."""
    print("=" * 60)
    print("Creating Test Dataset Directory")
    print("=" * 60)
    
    if not os.path.exists(DATASET_DIR):
        print(f"ERROR: Dataset directory not found: {DATASET_DIR}")
        return
    
    # Load dataset
    image_paths, labels, label_names = load_dataset(DATASET_DIR)
    
    # Use the SAME split logic as train_custom_model.py
    # This ensures we get the exact same test set
    train_paths, temp_paths, train_labels, temp_labels = train_test_split(
        image_paths, labels, test_size=0.3, random_state=42, stratify=labels
    )
    
    val_paths, test_paths, val_labels, test_labels = train_test_split(
        temp_paths, temp_labels, test_size=0.5, random_state=42, stratify=temp_labels
    )
    
    print(f"\nDataset split (same as training):")
    print(f"- Training samples: {len(train_paths)} (70%)")
    print(f"- Validation samples: {len(val_paths)} (15%)")
    print(f"- Test samples: {len(test_paths)} (15%)")
    
    # Create test dataset directory
    if os.path.exists(TEST_DATASET_DIR):
        print(f"\nRemoving existing test dataset directory...")
        shutil.rmtree(TEST_DATASET_DIR)
    
    os.makedirs(TEST_DATASET_DIR, exist_ok=True)
    print(f"\nCreating test dataset directory: {TEST_DATASET_DIR}")
    
    # Copy test images to new directory
    copied_count = 0
    for img_path, label_idx in zip(test_paths, test_labels):
        class_name = label_names[label_idx]
        
        # Create class directory if not exists
        class_dir = os.path.join(TEST_DATASET_DIR, class_name)
        os.makedirs(class_dir, exist_ok=True)
        
        # Copy image
        img_filename = os.path.basename(img_path)
        dest_path = os.path.join(class_dir, img_filename)
        shutil.copy2(img_path, dest_path)
        
        copied_count += 1
        if copied_count % 50 == 0:
            print(f"Copied {copied_count}/{len(test_paths)} images...")
    
    print(f"\n✓ Successfully copied {copied_count} test images to {TEST_DATASET_DIR}")
    
    # Print per-class statistics
    print("\nTest set distribution:")
    print("-" * 60)
    class_counts = {}
    for label_idx in test_labels:
        class_name = label_names[label_idx]
        class_counts[class_name] = class_counts.get(class_name, 0) + 1
    
    for class_name in sorted(class_counts.keys()):
        count = class_counts[class_name]
        print(f"{class_name.ljust(50)} {count} images")
    
    print("\n" + "=" * 60)
    print("Test dataset created successfully!")
    print("=" * 60)
    print(f"\nYou can now run the Dart test script:")
    print(f"  cd {PROJECT_DIR}")
    print(f"  dart test/test_tflite_model.dart")

if __name__ == "__main__":
    create_test_dataset()
