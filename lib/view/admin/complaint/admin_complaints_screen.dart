import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/view/user_app/drawer/drawer.dart';
import 'package:easy_xchange/viewModel/complaint_controller.dart';
import 'package:easy_xchange/viewModel/model/complaint_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class AdminComplaintsScreen extends StatefulWidget {
  const AdminComplaintsScreen({super.key});

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComplaintProvider>().fetchComplaints();
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('status: ${complaint}');

    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        title: text("Complaints Management",
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
      body: Consumer<ComplaintProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildFilterChips(provider),
              const SizedBox(height: 8),
              Expanded(
                child: _buildComplaintBody(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(ComplaintProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: ComplaintProvider.filterOptions.map((status) {
          return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Theme(
                data: Theme.of(context).copyWith(
                  chipTheme: Theme.of(context).chipTheme.copyWith(
                        checkmarkColor:
                            AppColors.whiteColor, // Force white checkmark
                      ),
                ),
                child: ChoiceChip(
                  label: text(
                    status,
                    color: provider.selectedFilter == status
                        ? AppColors.whiteColor
                        : AppColors.textcolorSecondary,
                  ),
                  selected: provider.selectedFilter == status,
                  onSelected: (selected) {
                    if (selected) provider.setFilter(status);
                  },
                  selectedColor: _getStatusColor(status),
                  backgroundColor: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: provider.selectedFilter == status
                          ? _getStatusColor(status)
                          : AppColors.borderColor,
                    ),
                  ),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ));
        }).toList(),
      ),
    );
  }

  Widget _buildComplaintBody(ComplaintProvider provider) {
    if (provider.hasError) {
      return _buildErrorState(provider);
    }

    if (provider.isLoading) {
      return _buildLoadingState();
    }

    if (provider.complaints.isEmpty) {
      return _buildEmptyState(provider.selectedFilter);
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: provider.complaints.length,
      itemBuilder: (context, index) {
        final complaint = provider.complaints[index];
        return _ComplaintCard(
          complaint: complaint,
          onStatusChanged: (newStatus) =>
              provider.updateComplaintStatus(complaint.id, newStatus),
        );
      },
    );
  }

  Widget _buildErrorState(ComplaintProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          text('Failed to load complaints',
              fontSize: textSizeLargeMedium, color: AppColors.redColor),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => provider.fetchComplaints(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: text('Try Again', color: AppColors.whiteColor),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomLoadingIndicator(color: AppColors.primaryColor),
          const SizedBox(height: 16),
          text('Loading complaints...',
              fontSize: textSizeMedium, color: AppColors.textcolorSecondary),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String filter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.report_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          text('No ${filter.toLowerCase()} complaints',
              fontSize: textSizeLargeMedium),
          const SizedBox(height: 8),
          text('When new complaints appear, they\'ll show up here',
              fontSize: textSizeMedium,
              color: AppColors.textcolorSecondary,
              isCentered: true),
        ],
      ).paddingSymmetric(horizontal: spacing_twinty),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Resolved':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      default:
        return AppColors.primaryColor;
    }
  }
}

class _ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final Function(String) onStatusChanged;

  const _ComplaintCard({
    required this.complaint,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderColor.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusIndicator(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: 12),
                      _buildComplaintContent(),
                      if (complaint.images != null &&
                          complaint.images!.isNotEmpty)
                        _buildImageAttachments(),
                      if (complaint.status != 'Resolved') _buildActionButtons(),
                      if (complaint.status == 'Resolved' &&
                          complaint.resolvedAt != null)
                        _buildResolutionInfo(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: 6,
      height: 80,
      decoration: BoxDecoration(
        color: _getStatusColor(complaint.status),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: text(complaint.title,
                  fontSize: textSizeLargeMedium, fontWeight: FontWeight.bold),
            ),
            text('#${complaint.id.substring(0, 6)}',
                fontSize: textSizeSmall, color: AppColors.textcolorSecondary),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.person_outline,
                size: 14, color: AppColors.textcolorSecondary),
            const SizedBox(width: 4),
            text(complaint.username,
                fontSize: textSizeSmall, color: AppColors.textcolorSecondary),
            const SizedBox(width: 12),
            Icon(Icons.credit_card_outlined,
                size: 14, color: AppColors.textcolorSecondary),
            const SizedBox(width: 4),
            text(complaint.cnicNo,
                fontSize: textSizeSmall, color: AppColors.textcolorSecondary),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.access_time,
                size: 14, color: AppColors.textcolorSecondary),
            const SizedBox(width: 4),
            text(_formatTimestamp(complaint.createdAt),
                fontSize: textSizeSmall, color: AppColors.textcolorSecondary),
          ],
        ),
      ],
    );
  }

  Widget _buildComplaintContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (complaint.category.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              height: 30,
              child: OutlinedButton(
                onPressed: () {},
                child: text(complaint.category,
                    fontSize: textSizeSmall,
                    color: Colors.green,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        text(complaint.description,
            fontSize: textSizeMedium, color: AppColors.primaryColor),
      ],
    );
  }

  Widget _buildImageAttachments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 8),
        text('Attachments',
            fontSize: textSizeSmall, fontWeight: FontWeight.bold),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: complaint.images!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    complaint.images![index],
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      color: AppColors.whiteColor,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildStatusButton(
                label: 'Mark as In Progress',
                icon: Icons.hourglass_top,
                color: Colors.orange,
                status: 'In Progress',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatusButton(
                label: 'Mark as Resolved',
                icon: Icons.check_circle,
                color: Colors.green,
                status: 'Resolved',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusButton({
    required String label,
    required IconData icon,
    required Color color,
    required String status,
  }) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 18, color: color),
      label: text(label, fontSize: textSizeSmall, color: color),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      onPressed: () => onStatusChanged(status),
    );
  }

  Widget _buildResolutionInfo() {
    return Column(
      children: [
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.verified_outlined, size: 16, color: Colors.green),
            const SizedBox(width: 8),
            text('Resolved on ${_formatTimestamp(complaint.resolvedAt!)}',
                fontSize: textSizeSmall, color: AppColors.textcolorSecondary),
          ],
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime date) {
    return DateFormat('MMM d, y • h:mm a').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Resolved':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      default:
        return AppColors.primaryColor;
    }
  }
}
