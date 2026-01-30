#!/usr/bin/env python3
"""
Quantize TorchScript model to reduce file size from ~327MB to ~100MB.
This uses dynamic quantization which maintains good accuracy while reducing size.
"""

import os
import torch

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)
TORCHSCRIPT_PATH = os.path.join(PROJECT_DIR, "models", "skin_disease_model.pt")
QUANTIZED_PATH = os.path.join(PROJECT_DIR, "models", "skin_disease_model_quantized.pt")
QUANTIZED_LITE_PATH = os.path.join(PROJECT_DIR, "models", "skin_disease_model_quantized.ptl")

def quantize_model():
    """Quantize TorchScript model to reduce file size."""
    print("=" * 60)
    print("Quantize TorchScript Model")
    print("=" * 60)
    
    # Check if model exists
    if not os.path.exists(TORCHSCRIPT_PATH):
        print(f"❌ Error: TorchScript model not found at {TORCHSCRIPT_PATH}")
        print(f"\nPlease run: python python_scripts/export_torchscript.py")
        return False
    
    # Load TorchScript model
    print(f"\nLoading TorchScript model from {TORCHSCRIPT_PATH}...")
    model = torch.jit.load(TORCHSCRIPT_PATH)
    model.eval()
    
    original_size = os.path.getsize(TORCHSCRIPT_PATH) / (1024 * 1024)
    print(f"✓ Model loaded")
    print(f"  Original size: {original_size:.2f} MB")
    
    # Quantize model
    print(f"\nQuantizing model (dynamic quantization)...")
    print(f"  This will convert Float32 weights to Int8...")
    
    quantized_model = torch.quantization.quantize_dynamic(
        model,
        {torch.nn.Linear},  # Quantize Linear layers
        dtype=torch.qint8
    )
    
    print(f"✓ Model quantized")
    
    # Save quantized model
    print(f"\nSaving quantized model...")
    quantized_model.save(QUANTIZED_PATH)
    
    quantized_size = os.path.getsize(QUANTIZED_PATH) / (1024 * 1024)
    reduction = ((original_size - quantized_size) / original_size) * 100
    
    print(f"✓ Quantized model saved: {QUANTIZED_PATH}")
    print(f"  Quantized size: {quantized_size:.2f} MB")
    print(f"  Size reduction: {reduction:.1f}%")
    
    # Optimize for mobile
    print(f"\nOptimizing quantized model for mobile...")
    try:
        from torch.utils.mobile_optimizer import optimize_for_mobile
        
        optimized_model = optimize_for_mobile(quantized_model)
        optimized_model._save_for_lite_interpreter(QUANTIZED_LITE_PATH)
        
        lite_size = os.path.getsize(QUANTIZED_LITE_PATH) / (1024 * 1024)
        print(f"✓ Quantized PyTorch Lite model saved: {QUANTIZED_LITE_PATH}")
        print(f"  File size: {lite_size:.2f} MB")
        
    except Exception as e:
        print(f"⚠️  Mobile optimization failed: {e}")
        print(f"  You can still use the regular quantized model")
    
    # Test quantized model
    print(f"\nTesting quantized model...")
    test_input = torch.randn(1, 3, 224, 224)
    
    with torch.no_grad():
        original_output = model(test_input)
        quantized_output = quantized_model(test_input)
        
        # Compare outputs
        max_diff = torch.max(torch.abs(original_output - quantized_output)).item()
        mean_diff = torch.mean(torch.abs(original_output - quantized_output)).item()
        
        print(f"✓ Quantized model tested")
        print(f"  Max difference: {max_diff:.6f}")
        print(f"  Mean difference: {mean_diff:.6f}")
        
        if max_diff < 0.1:
            print(f"  ✓ Quantization quality: Excellent")
        elif max_diff < 0.5:
            print(f"  ✓ Quantization quality: Good")
        else:
            print(f"  ⚠️  Quantization quality: Fair (may affect accuracy)")
    
    print("\n" + "=" * 60)
    print("✓ QUANTIZATION COMPLETED!")
    print("=" * 60)
    print(f"\nFiles created:")
    print(f"  Quantized model: {QUANTIZED_PATH} ({quantized_size:.2f} MB)")
    if os.path.exists(QUANTIZED_LITE_PATH):
        print(f"  Quantized Lite model: {QUANTIZED_LITE_PATH} ({lite_size:.2f} MB)")
    
    print(f"\nSize comparison:")
    print(f"  Original: {original_size:.2f} MB")
    print(f"  Quantized: {quantized_size:.2f} MB")
    print(f"  Reduction: {reduction:.1f}%")
    
    print(f"\nNext steps:")
    print(f"  1. Use quantized model for mobile deployment")
    print(f"  2. Copy to Flutter assets: {QUANTIZED_PATH}")
    print(f"  3. Update Flutter code to use quantized model")
    
    print(f"\nNote:")
    print(f"  - Quantized model is smaller but may have slightly lower accuracy")
    print(f"  - Test on real data to ensure accuracy is acceptable")
    print(f"  - If accuracy drops too much, use original model instead")
    
    return True

if __name__ == "__main__":
    try:
        success = quantize_model()
        exit(0 if success else 1)
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        exit(1)
