import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinaware_client/skinaware_client.dart';
import 'package:skinaware_flutter/general_components/loading_dialog.dart';
import 'package:skinaware_flutter/general_components/pop.dart';
import 'package:skinaware_flutter/providers/serverpod_provider.dart';
import 'package:skinaware_flutter/providers/userProvider.dart';

class EditProfileDialog extends ConsumerStatefulWidget {
  final User user;

  const EditProfileDialog({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  ConsumerState<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<EditProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;

  late Gender _selectedGender;
  late SkinType _selectedSkinType;
  late Role _selectedRole;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _ageController = TextEditingController(text: widget.user.age.toString());

    _selectedGender = widget.user.gender;
    _selectedSkinType = widget.user.skinType;
    _selectedRole = widget.user.role;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final ageText = _ageController.text.trim();

    if (name.isEmpty || name.length < 2) {
      showTopToast(
        context,
        'Name must be at least 2 characters',
        isSuccess: false,
      );
      return;
    }

    if (phone.isEmpty || phone.length < 7) {
      showTopToast(context, 'Invalid phone number', isSuccess: false);
      return;
    }

    final age = int.tryParse(ageText);
    if (age == null || age < 1 || age > 120) {
      showTopToast(context, 'Invalid age', isSuccess: false);
      return;
    }

    try {
      LoadingDialog.show(context);

      final client = ref.read(serverpodClientProvider);
      final userId = widget.user.id;

      if (userId == null) {
        Navigator.of(context).pop();
        showTopToast(context, 'User ID not found', isSuccess: false);
        return;
      }

      final response = await client.user.updateProfile(
        userId: userId,
        name: name,
        phone: phone,
        age: age,
        gender: _selectedGender,
        role: _selectedRole,
        skinType: _selectedSkinType,
      );

      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (!response.success) {
        if (context.mounted) {
          showTopToast(
            context,
            response.error ?? 'Failed to update profile',
            isSuccess: false,
          );
        }
        return;
      }

      if (response.user != null) {
        ref.read(userProvider.notifier).updateUser(response.user!);
      }

      if (context.mounted) {
        showTopToast(context, 'Profile updated successfully', isSuccess: true);
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        showTopToast(context, 'Error: $e', isSuccess: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.edit_outlined, color: Color(0xFF0284C7)),
                  SizedBox(width: 12),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 24),

              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16),

              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),

              _buildTextField(
                controller: _ageController,
                label: 'Age',
                icon: Icons.cake_outlined,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),

              _buildDropdown<Gender>(
                label: 'Gender',
                value: _selectedGender,
                items: Gender.values,
                onChanged: (value) => setState(() => _selectedGender = value!),
                itemBuilder: (gender) => _formatEnumName(gender.name),
              ),
              SizedBox(height: 16),

              _buildDropdown<SkinType>(
                label: 'Skin Type',
                value: _selectedSkinType,
                items: SkinType.values,
                onChanged: (value) =>
                    setState(() => _selectedSkinType = value!),
                itemBuilder: (skinType) => _formatEnumName(skinType.name),
              ),
              SizedBox(height: 16),

              _buildDropdown<Role>(
                label: 'Role',
                value: _selectedRole,
                items: Role.values,
                onChanged: (value) => setState(() => _selectedRole = value!),
                itemBuilder: (role) => _formatEnumName(role.name),
              ),
              SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Color(0xFF0284C7)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF0284C7), width: 2),
            ),
            filled: true,
            fillColor: Color(0xFFF8FAFC),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE2E8F0)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemBuilder(item),
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  String _formatEnumName(String name) {
    return name
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
