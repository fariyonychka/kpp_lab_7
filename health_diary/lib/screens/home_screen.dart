import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../l10n/app_localizations.dart';
import '../widgets/sidebar_item.dart';
import '../theme/app_colors.dart';
import '../core/analytics_service.dart';

import '../core/history_provider.dart';
import '../core/record.dart';
import '../repositories/health_repository.dart';
import '../models/user_profile.dart';
import 'home_screen_controller.dart';
import 'history_screen.dart';
import 'food_record_screen.dart';
import 'mood_record_screen.dart';
import 'sleep_record_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  String userName = 'Користувач';
  final _controller = HomeScreenController();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView('home');
    final user = FirebaseAuth.instance.currentUser;
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      userName = user.displayName!;
    }

    // Ensure profile exists in Firestore
    if (user != null) {
      HealthRepository().ensureUserProfileExists(
        name: user.displayName ?? 'Користувач',
        email: user.email ?? '',
      );
    }

    _controller.setNavigateToHome(() => setState(() => selectedIndex = 0));

    _pages = [
      const _HomeDashboard(),
      SleepRecordScreen(controller: _controller),
      FoodRecordScreen(controller: _controller),
      MoodRecordScreen(controller: _controller),
      const HistoryScreen(),
      const SettingsScreen(),
    ];
  }

  void _onSidebarTap(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 250,
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 40),
                    child: Text(
                      loc.appTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const Divider(height: 1, color: Colors.white24),

                const SizedBox(height: 20),
                SidebarItem(
                  title: loc.home,
                  isActive: selectedIndex == 0,
                  onTap: () => _onSidebarTap(0),
                ),
                SidebarItem(
                  title: loc.sleep,
                  isActive: selectedIndex == 1,
                  onTap: () => _onSidebarTap(1),
                ),
                SidebarItem(
                  title: loc.food,
                  isActive: selectedIndex == 2,
                  onTap: () => _onSidebarTap(2),
                ),
                SidebarItem(
                  title: loc.mood,
                  isActive: selectedIndex == 3,
                  onTap: () => _onSidebarTap(3),
                ),
                SidebarItem(
                  title: loc.history,
                  isActive: selectedIndex == 4,
                  onTap: () => _onSidebarTap(4),
                ),
                SidebarItem(
                  title: loc.settings,
                  isActive: selectedIndex == 5,
                  onTap: () => _onSidebarTap(5),
                ),

                const Spacer(),
              ],
            ),
          ),

          Expanded(child: _pages[selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData iconData,
    required String title,
    required String subtitle,
    required Color color,
    required int targetIndex,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedIndex = targetIndex),
        child: SizedBox(
          height: 205,
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Icon(iconData, size: 24, color: color),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryProvider(),
      child: const _HomeDashboardContent(),
    );
  }
}

class _HomeDashboardContent extends StatelessWidget {
  const _HomeDashboardContent();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final userName =
        FirebaseAuth.instance.currentUser?.displayName ?? 'Користувач';
    final homeState = context.findAncestorStateOfType<_HomeScreenState>()!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<UserProfile?>(
            stream: HealthRepository().getUserProfileStream(),
            builder: (context, snapshot) {
              final profileName = snapshot.data?.name;
              final displayName =
                  (profileName != null && profileName.isNotEmpty)
                  ? profileName
                  : (userName.isNotEmpty ? userName : 'Користувач');

              return Text(
                loc.goodMorning(displayName),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
          Text(
            loc.howAreYou,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 30),

          Row(
            children: [
              homeState._buildActionCard(
                iconData: Icons.bed,
                title: loc.recordSleep,
                subtitle: loc.sleepSubtitle,
                color: AppColors.iconSleep,
                targetIndex: 1,
              ),
              const SizedBox(width: 20),
              homeState._buildActionCard(
                iconData: Icons.food_bank_rounded,
                title: loc.recordFood,
                subtitle: loc.foodSubtitle,
                color: AppColors.iconFood,
                targetIndex: 2,
              ),
              const SizedBox(width: 20),
              homeState._buildActionCard(
                iconData: Icons.mood,
                title: loc.recordMood,
                subtitle: loc.moodSubtitle,
                color: AppColors.iconMood,
                targetIndex: 3,
              ),
            ],
          ),

          const SizedBox(height: 40),

          Text(
            loc.recentRecords,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),

          const _RecentRecordsList(),
        ],
      ),
    );
  }
}

class _RecentRecordsList extends StatelessWidget {
  const _RecentRecordsList();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();

    if (provider.status == HistoryStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Take top 5 records
    final records = provider.records.take(5).toList();

    if (records.isEmpty) {
      return const _EmptyRecentRecords();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: records.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _RecentRecordCard(record: records[index]);
      },
    );
  }
}

class _EmptyRecentRecords extends StatelessWidget {
  const _EmptyRecentRecords();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            loc.noRecords,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentRecordCard extends StatefulWidget {
  final HealthRecord record;

  const _RecentRecordCard({required this.record});

  @override
  State<_RecentRecordCard> createState() => _RecentRecordCardState();
}

class _RecentRecordCardState extends State<_RecentRecordCard> {
  bool _isHovered = false;

  String _getRecordTitle(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (widget.record.type) {
      case RecordType.sleep:
        return loc.sleepRecord;
      case RecordType.mood:
        return loc.moodRecord;
      case RecordType.food:
        return loc.foodRecord;
    }
  }

  String _translateValue(BuildContext context, String key, dynamic value) {
    final loc = AppLocalizations.of(context)!;
    final strVal = value.toString();

    if (key == 'quality') {
      return switch (strVal) {
        'poor' => loc.poor,
        'good' => loc.good,
        'excellent' => loc.sleepExcellent,
        _ => strVal,
      };
    } else if (key == 'mood') {
      return switch (strVal) {
        'happy' => loc.happy,
        'neutral' => loc.neutral,
        'sad' => loc.sad,
        'stressed' => loc.stressed,
        _ => strVal,
      };
    } else if (key == 'physical') {
      return switch (strVal) {
        'bad' => loc.bad,
        'good' => loc.goodState,
        'excellent' => loc.excellent,
        _ => strVal,
      };
    }
    return strVal;
  }

  String _getRecordSubtitle(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (widget.record.type) {
      case RecordType.sleep:
        final duration = widget.record.details['duration'];
        final quality = widget.record.details['quality'];
        final qualityStr = _translateValue(context, 'quality', quality);
        return '$duration ${loc.hours} · $qualityStr';
      case RecordType.mood:
        final energy = widget.record.details['energy'];
        final physical = widget.record.details['physical'];
        final physicalStr = _translateValue(context, 'physical', physical);
        return '${loc.energy}: $energy · $physicalStr';
      case RecordType.food:
        return '${widget.record.title} · ${widget.record.subtitle}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrls = widget.record.details['photoUrls'] as List<String>? ?? [];
    final hasPhoto =
        widget.record.type == RecordType.food && photoUrls.isNotEmpty;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => showRecordDetail(context, widget.record),
        child: Card(
          elevation: 0,
          color: _isHovered ? Colors.grey[50] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: widget.record.color.withOpacity(0.1),
              radius: 24,
              child: Icon(
                widget.record.iconData,
                color: widget.record.color,
                size: 24,
              ),
            ),
            title: Text(
              _getRecordTitle(context),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              _getRecordSubtitle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasPhoto) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: photoUrls.first,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[100]),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Text(
                  '${widget.record.date.day}/${widget.record.date.month} ${widget.record.date.hour}:${widget.record.date.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
