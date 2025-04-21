import 'package:easy_xchange/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/widget.dart';

class PostCard extends StatelessWidget {
  final String title;
  final String createdAt;
  final String desc;
  final String amount;
  final String type;
  final String distance;
  final bool isUpdate;
  final Color? color;
  final VoidCallback? updateOnTap;
  final VoidCallback? deleteOnTap;

  const PostCard({
    required this.title,
    required this.createdAt,
    required this.desc,
    required this.amount,
    required this.type,
    required this.distance,
    this.isUpdate = false,
    this.color,
    this.deleteOnTap,
    this.updateOnTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: AppColors.primaryColor.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title section with divider
            Row(
              children: [
                Expanded(
                  child: text(
                    title,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors
                        .primaryColor, // Dark slate blue - professional color
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: text(
                    distance,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            text(
              createdAt,
              fontSize: 12.0,
              color: AppColors
                  .primaryColor, // Dark slate blue - professional color
            ),
            const Divider(height: 24),

            // Details section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - information
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      text(
                        desc,
                        fontSize: 14.0,
                        color: Colors.grey[700],
                        maxLine: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),

                      // Payment type and amount
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              Icons.account_balance_wallet,
                              "Payment Source",
                              type.replaceAll("Payment Source: ", ""),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildInfoItem(
                              Icons.currency_exchange,
                              "Amount",
                              amount.replaceAll("Amount: ", ""),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Actions section
            isUpdate
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: deleteOnTap,
                          icon: const Icon(Icons.delete_outline,
                              size: 25, color: Colors.red),
                          label: text("Delete",
                              color: AppColors.redColor,
                              fontSize: textSizeSMedium),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: updateOnTap,
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: AppColors.whiteColor,
                          ),
                          label: text("Update",
                              color: AppColors.whiteColor,
                              fontSize: textSizeSMedium),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
