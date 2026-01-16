import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/menu_item.dart';

class AdminMenuFormScreen extends StatefulWidget {
  final MenuItem? item;

  AdminMenuFormScreen({this.item});

  @override
  State<AdminMenuFormScreen> createState() => _AdminMenuFormScreenState();
}

class _AdminMenuFormScreenState extends State<AdminMenuFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final prepTimeCtrl = TextEditingController();
  final imageUrlCtrl = TextEditingController();
  bool isVegetarian = false;
  bool isSpicy = false;
  bool isAvailable = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      nameCtrl.text = widget.item!.name;
      descCtrl.text = widget.item!.description;
      priceCtrl.text = widget.item!.price.toString();
      prepTimeCtrl.text = widget.item!.preparationTime.toString();
      imageUrlCtrl.text = widget.item!.imageUrl;
      isVegetarian = widget.item!.isVegetarian;
      isSpicy = widget.item!.isSpicy;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final data = {
        'name': nameCtrl.text.trim(),
        'description': descCtrl.text.trim(),
        'category': categoryCtrl.text.trim().isEmpty
            ? 'Món chính'
            : categoryCtrl.text.trim(),
        'price': double.parse(priceCtrl.text),
        'preparationTime': int.parse(prepTimeCtrl.text),
        'isVegetarian': isVegetarian,
        'isSpicy': isSpicy,
        'isAvailable': isAvailable,
        'imageUrl': imageUrlCtrl.text.trim(),
      };

      if (widget.item == null) {
        await ApiService.createMenuItem(data);
      } else {
        await ApiService.updateMenuItem(widget.item!.id, data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.item == null
                ? 'Đã thêm món mới'
                : 'Đã cập nhật món'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Thêm Món Mới' : 'Sửa Món'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Tên món *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Vui lòng nhập tên món' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: descCtrl,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: categoryCtrl,
              decoration: InputDecoration(
                labelText: 'Danh mục',
                hintText: 'Món chính, Khai vị, Canh...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: priceCtrl,
              decoration: InputDecoration(
                labelText: 'Giá *',
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Vui lòng nhập giá';
                if (double.tryParse(v) == null) return 'Giá không hợp lệ';
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: prepTimeCtrl,
              decoration: InputDecoration(
                labelText: 'Thời gian chế biến (phút) *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty)
                  return 'Vui lòng nhập thời gian';
                if (int.tryParse(v) == null) return 'Thời gian không hợp lệ';
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: imageUrlCtrl,
              decoration: InputDecoration(
                labelText: 'URL hình ảnh',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Món chay'),
              value: isVegetarian,
              onChanged: (v) => setState(() => isVegetarian = v),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            SizedBox(height: 8),
            SwitchListTile(
              title: Text('Món cay'),
              value: isSpicy,
              onChanged: (v) => setState(() => isSpicy = v),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            SizedBox(height: 8),
            SwitchListTile(
              title: Text('Còn hàng'),
              value: isAvailable,
              onChanged: (v) => setState(() => isAvailable = v),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.item == null ? 'Thêm Món' : 'Cập Nhật',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    categoryCtrl.dispose();
    priceCtrl.dispose();
    prepTimeCtrl.dispose();
    imageUrlCtrl.dispose();
    super.dispose();
  }
}
