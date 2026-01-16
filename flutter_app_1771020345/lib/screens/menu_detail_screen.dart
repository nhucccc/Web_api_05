import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuDetailScreen extends StatelessWidget {
  final MenuItem item;

  MenuDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                item.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              background: item.imageUrl.isNotEmpty
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: Icon(
                                Icons.image_not_supported,
                                size: 64,
                                color: Colors.grey.shade500,
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: Colors.grey.shade300,
                      child: Icon(
                        Icons.restaurant,
                        size: 64,
                        color: Colors.grey.shade500,
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade50,
                    Colors.white,
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade200,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildInfoChip(
                          icon: item.isVegetarian ? Icons.eco : Icons.restaurant,
                          label: item.isVegetarian ? 'Chay' : 'Mặn',
                          color: item.isVegetarian
                              ? Colors.green
                              : Colors.red,
                        ),
                        _buildInfoChip(
                          icon: item.isSpicy
                              ? Icons.local_fire_department
                              : Icons.ac_unit,
                          label: item.isSpicy ? 'Cay' : 'Không cay',
                          color: item.isSpicy
                              ? Colors.orange
                              : Colors.blue,
                        ),
                        _buildInfoChip(
                          icon: Icons.timer,
                          label: '${item.preparationTime} phút',
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Divider(),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: Colors.blue.shade600,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Mô tả món ăn',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Text(
                        item.description.isNotEmpty
                            ? item.description
                            : 'Chưa có mô tả cho món ăn này.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              icon: Icons.attach_money,
                              label: 'Giá',
                              value: '\$${item.price.toStringAsFixed(2)}',
                              color: Colors.green,
                            ),
                            Divider(height: 24),
                            _buildDetailRow(
                              icon: Icons.timer_outlined,
                              label: 'Thời gian chế biến',
                              value: '${item.preparationTime} phút',
                              color: Colors.orange,
                            ),
                            Divider(height: 24),
                            _buildDetailRow(
                              icon: Icons.restaurant_menu,
                              label: 'Loại món',
                              value: item.isVegetarian ? 'Món chay' : 'Món mặn',
                              color: item.isVegetarian
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            Divider(height: 24),
                            _buildDetailRow(
                              icon: Icons.local_fire_department,
                              label: 'Độ cay',
                              value: item.isSpicy ? 'Có cay' : 'Không cay',
                              color: item.isSpicy
                                  ? Colors.deepOrange
                                  : Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
