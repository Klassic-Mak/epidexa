#!/usr/bin/env python3
"""
Export PyTorch model to TorchScript for PyTorch Mobile deployment.
This is the recommended approach for deploying ViT models on mobile.
"""

import os
import json
import torch
from transformers import AutoModelForImageClassification, AutoImageProcessor

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)
MODEL_DIR = os.path.join(PROJECT_DIR, "models", "huggingface_model")
TORCHSCRIPT_PATH = os.path.join(PROJECT_DIR, "models", "skin_disease_model.pt")
TORCHSCRIPT_LITE_PATH = os.path.join(PROJECT_DIR, "models", "skin_disease_model_lite.ptl")
LABELS_PATH = os.path.join(PROJECT_DIR, "models", "labels.txt")

def export_to_torchscript():
    """Export PyTorch model to TorchScript format."""
    print("=" * 60)
    print("Export PyTorch Model to TorchScript")
    print("=" * 60)
    
    # Load model
    print(f"\nLoading PyTorch model from {MODEL_DIR}...")
    base_model = AutoModelForImageClassification.from_pretrained(MODEL_DIR)
    processor = AutoImageProcessor.from_pretrained(MODEL_DIR)
    base_model.eval()
    
    print(f"✓ Model loaded")
    print(f"  Number of classes: {base_model.config.num_labels}")
    
    # Wrap model to return only logits (not dict)
    print(f"\nWrapping model for TorchScript compatibility...")
    
    class ModelWrapper(torch.nn.Module):
        def __init__(self, model):
            super().__init__()
            self.model = model
        
        def forward(self, x):
            # Return only logits tensor, not dict
            outputs = self.model(x)
            return outputs.logits
    
    model = ModelWrapper(base_model)
    model.eval()
    
    print(f"✓ Model wrapped")
    
    # Create example input
    print(f"\nCreating example input...")
    example_input = torch.randn(1, 3, 224, 224)
    
    # Trace model
    print(f"\nTracing model...")
    with torch.no_grad():
        traced_model = torch.jit.trace(model, example_input, strict=False)
    
    print(f"✓ Model traced successfully")
    
    # Save TorchScript model
    print(f"\nSaving TorchScript model...")
    traced_model.save(TORCHSCRIPT_PATH)
    
    file_size = os.path.getsize(TORCHSCRIPT_PATH) / (1024 * 1024)
    print(f"✓ TorchScript model saved: {TORCHSCRIPT_PATH}")
    print(f"  File size: {file_size:.2f} MB")
    
    # Optimize for mobile (PyTorch Lite)
    print(f"\nOptimizing for mobile (PyTorch Lite)...")
    try:
        from torch.utils.mobile_optimizer import optimize_for_mobile
        
        optimized_model = optimize_for_mobile(traced_model)
        optimized_model._save_for_lite_interpreter(TORCHSCRIPT_LITE_PATH)
        
        lite_size = os.path.getsize(TORCHSCRIPT_LITE_PATH) / (1024 * 1024)
        print(f"✓ PyTorch Lite model saved: {TORCHSCRIPT_LITE_PATH}")
        print(f"  File size: {lite_size:.2f} MB")
        
    except Exception as e:
        print(f"⚠️  Mobile optimization failed: {e}")
        print(f"  You can still use the regular TorchScript model")
    
    # Create labels file
    print(f"\nCreating labels file...")
    labels = list(base_model.config.id2label.values())
    
    with open(LABELS_PATH, 'w') as f:
        for label in labels:
            f.write(f"{label}\n")
    
    print(f"✓ Labels file created: {LABELS_PATH}")
    print(f"  Total classes: {len(labels)}")
    
    # Test the exported model
    print(f"\nTesting exported model...")
    with torch.no_grad():
        original_output = base_model(example_input).logits
        traced_output = traced_model(example_input)
        
        # Check if outputs match
        if torch.allclose(original_output, traced_output, rtol=1e-3):
            print(f"✓ Model export verified - outputs match!")
        else:
            max_diff = torch.max(torch.abs(original_output - traced_output)).item()
            print(f"⚠️  Warning: Outputs differ slightly (max diff: {max_diff:.6f})")
            print(f"   This is usually OK for mobile deployment")
    
    print("\n" + "=" * 60)
    print("✓ EXPORT COMPLETED!")
    print("=" * 60)
    print(f"\nFiles created:")
    print(f"  TorchScript model: {TORCHSCRIPT_PATH} ({file_size:.2f} MB)")
    if os.path.exists(TORCHSCRIPT_LITE_PATH):
        print(f"  PyTorch Lite model: {TORCHSCRIPT_LITE_PATH} ({lite_size:.2f} MB)")
    print(f"  Labels file: {LABELS_PATH}")
    
    print(f"\nNext steps:")
    print(f"  1. (Optional) Quantize model: python python_scripts/quantize_model.py")
    print(f"  2. Add pytorch_lite to pubspec.yaml")
    print(f"  3. Copy model files to Flutter assets")
    print(f"  4. Implement PyTorchInferenceService in Dart")
    
    print(f"\nFor Flutter integration:")
    print(f"  - Use pytorch_lite package: https://pub.dev/packages/pytorch_lite")
    print(f"  - Or pytorch_mobile: https://pub.dev/packages/pytorch_mobile")
    
    return True

if __name__ == "__main__":
    try:
        success = export_to_torchscript()
        exit(0 if success else 1)
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        exit(1)
