#!/usr/bin/env python3
"""
Train custom skin disease detection model using your own dataset
"""

import os
import json
from pathlib import Path
from PIL import Image
import torch
from torch.utils.data import Dataset
from transformers import AutoImageProcessor, AutoModelForImageClassification, TrainingArguments, Trainer
from sklearn.model_selection import train_test_split
import numpy as np

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)
DATASET_DIR = os.path.join(PROJECT_DIR, "dataset")
MODEL_DIR = os.path.join(PROJECT_DIR, "models", "huggingface_model")
OUTPUT_DIR = os.path.join(PROJECT_DIR, "models", "custom_trained_model")
BATCH_SIZE = 16
EPOCHS = 10
LEARNING_RATE = 2e-5

class SkinDiseaseDataset(Dataset):
    def __init__(self, image_paths, labels, processor, augment=False):
        self.image_paths = image_paths
        self.labels = labels
        self.processor = processor
        self.augment = augment

    def __len__(self):
        return len(self.image_paths)

    def __getitem__(self, idx):
        image = Image.open(self.image_paths[idx]).convert('RGB')
        
        if self.augment:
            pass
        
        encoding = self.processor(images=image, return_tensors="pt")
        encoding = {k: v.squeeze() for k, v in encoding.items()}
        encoding['labels'] = self.labels[idx]
        
        return encoding

def load_dataset(dataset_dir):
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
    print(f"Classes: {label_names}")
    
    return image_paths, labels, label_names

def train_model():
    print("=" * 60)
    print("Training Custom Skin Disease Detection Model")
    print("=" * 60)
    
    image_paths, labels, label_names = load_dataset(DATASET_DIR)
    
    train_paths, val_paths, train_labels, val_labels = train_test_split(
        image_paths, labels, test_size=0.2, random_state=42, stratify=labels
    )
    
    print(f"\nDataset split:")
    print(f"- Training samples: {len(train_paths)}")
    print(f"- Validation samples: {len(val_paths)}")
    
    processor = AutoImageProcessor.from_pretrained(MODEL_DIR)
    model = AutoModelForImageClassification.from_pretrained(
        MODEL_DIR,
        num_labels=len(label_names),
        ignore_mismatched_sizes=True
    )
    
    model.config.id2label = {i: label for i, label in enumerate(label_names)}
    model.config.label2id = {label: i for i, label in enumerate(label_names)}
    
    train_dataset = SkinDiseaseDataset(train_paths, train_labels, processor, augment=True)
    val_dataset = SkinDiseaseDataset(val_paths, val_labels, processor, augment=False)
    
    training_args = TrainingArguments(
        output_dir=OUTPUT_DIR,
        num_train_epochs=EPOCHS,
        per_device_train_batch_size=BATCH_SIZE,
        per_device_eval_batch_size=BATCH_SIZE,
        learning_rate=LEARNING_RATE,
        warmup_steps=100,
        weight_decay=0.01,
        logging_dir=f'{OUTPUT_DIR}/logs',
        logging_steps=10,
        eval_strategy="epoch",
        save_strategy="epoch",
        load_best_model_at_end=True,
        metric_for_best_model="accuracy",
        save_total_limit=2,
    )
    
    def compute_metrics(eval_pred):
        predictions, labels = eval_pred
        predictions = np.argmax(predictions, axis=1)
        accuracy = (predictions == labels).mean()
        return {'accuracy': accuracy}
    
    trainer = Trainer(
        model=model,
        args=training_args,
        train_dataset=train_dataset,
        eval_dataset=val_dataset,
        compute_metrics=compute_metrics,
    )
    
    print("\nStarting training...")
    trainer.train()
    
    print("\nSaving model...")
    trainer.save_model(OUTPUT_DIR)
    processor.save_pretrained(OUTPUT_DIR)
    
    with open(os.path.join(OUTPUT_DIR, 'labels.json'), 'w') as f:
        json.dump(label_names, f, indent=2)
    
    print(f"✓ Training completed! Model saved to {OUTPUT_DIR}")
    
    results = trainer.evaluate()
    print("\nFinal evaluation results:")
    for key, value in results.items():
        print(f"- {key}: {value:.4f}")

if __name__ == "__main__":
    train_model()
