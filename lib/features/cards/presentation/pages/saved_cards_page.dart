import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cardscan_app/core/utils/export_helper.dart';
import 'package:cardscan_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:cardscan_app/core/widgets/app_empty_state.dart';
import 'package:cardscan_app/core/widgets/app_search_field.dart';
import 'package:cardscan_app/core/widgets/app_selection_action_bar.dart';
import 'package:cardscan_app/features/cards/domain/entities/visiting_card.dart';
import 'package:cardscan_app/features/cards/presentation/controllers/cards_providers.dart';
import 'package:cardscan_app/features/cards/presentation/pages/card_scanner_page.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/card_filter_chips.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/cards_header.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/insights_tab.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/quick_insight_card.dart';
import 'package:cardscan_app/features/cards/presentation/widgets/visiting_card_list_item.dart';

class SavedCardsPage extends ConsumerStatefulWidget {
  const SavedCardsPage({super.key});

  @override
  ConsumerState<SavedCardsPage> createState() => _SavedCardsPageState();
}

class _SavedCardsPageState extends ConsumerState<SavedCardsPage> {
  static const _filters = ['All', 'Company', 'Recently Added', 'Job Title'];
  static const _navItems = [
    AppBottomNavItem(icon: Icons.style, label: 'Cards'),
    AppBottomNavItem(icon: Icons.insights, label: 'Insights'),
    AppBottomNavItem(icon: Icons.settings, label: 'Settings'),
  ];

  int _currentTabIndex = 0;
  String _searchQuery = '';
  String _activeFilter = 'All';
  bool _isSelecting = false;
  final Set<int> _selectedCardIds = {};
  final Set<int> _expandedCardIds = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(cardsStreamProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: _buildBody(context, cardsAsync),
      floatingActionButton: _currentTabIndex == 0
          ? _buildScanButton(context)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isSelecting && _currentTabIndex == 0)
            _buildSelectionBar(cardsAsync),
          AppBottomNavBar(
            items: _navItems,
            currentIndex: _currentTabIndex,
            onChanged: _setCurrentTab,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
        child: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            'JD',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
      titleSpacing: 12,
      title: Text(
        'CardScan',
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          color: colorScheme.primary,
          onPressed: () => _setCurrentTab(0),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          color: colorScheme.primary,
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationName: 'CardScan',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2026 CardScan Inc.',
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncValue<List<VisitingCard>> cardsAsync,
  ) {
    switch (_currentTabIndex) {
      case 1:
        return cardsAsync.when(
          data: (cards) => InsightsTab(cards: cards),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        );
      case 2:
        return _SettingsTab(
          cardsAsync: cardsAsync,
          onExportCards: ExportHelper.shareAsCsv,
        );
      case 0:
      default:
        return _buildCardsTab(cardsAsync);
    }
  }

  Widget _buildCardsTab(AsyncValue<List<VisitingCard>> cardsAsync) {
    return cardsAsync.when(
      data: (cards) {
        final filteredCards = _filterCards(cards);

        return RefreshIndicator(
          onRefresh: () async => ref.refresh(cardsStreamProvider),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                sliver: SliverToBoxAdapter(
                  child: _CardsToolbar(
                    totalCards: cards.length,
                    isSelecting: _isSelecting,
                    searchController: _searchController,
                    filters: _filters,
                    activeFilter: _activeFilter,
                    onToggleSelection: _toggleSelectionMode,
                    onSearchChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    onFilterSelected: (filter) {
                      setState(() => _activeFilter = filter);
                    },
                  ),
                ),
              ),
              if (filteredCards.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    icon: Icons.contact_mail_outlined,
                    title: 'No cards yet',
                    message:
                        'Scan your first business card to start organizing your network.',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == filteredCards.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 80),
                          child: QuickInsightCard(
                            cards: cards,
                            onViewInsights: () => _setCurrentTab(1),
                          ),
                        );
                      }

                      final card = filteredCards[index];
                      return VisitingCardListItem(
                        card: card,
                        isExpanded: _expandedCardIds.contains(card.id),
                        isSelecting: _isSelecting,
                        isSelected: _selectedCardIds.contains(card.id),
                        onTap: () => _handleCardTap(card.id),
                        onCopy: _copyToClipboard,
                        onSaveContact: ExportHelper.saveToDeviceContacts,
                        onDelete: _deleteCard,
                      );
                    }, childCount: filteredCards.length + 1),
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading cards: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildSelectionBar(AsyncValue<List<VisitingCard>> cardsAsync) {
    return cardsAsync.maybeWhen(
      data: (cards) => AppSelectionActionBar(
        selectedCount: _selectedCardIds.length,
        onCancel: _clearSelection,
        onShare: () => _shareSelectedCards(cards),
        onDelete: () => _deleteSelectedCards(cards),
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildScanButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FloatingActionButton.extended(
      elevation: 4,
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimary,
      icon: const Icon(Icons.photo_camera),
      label: const Text(
        'Scan Card',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CardScannerPage()),
        );
      },
    );
  }

  List<VisitingCard> _filterCards(List<VisitingCard> cards) {
    final query = _searchQuery.toLowerCase().trim();
    final filteredCards = cards.where((card) {
      final matchesQuery =
          query.isEmpty ||
          card.name.toLowerCase().contains(query) ||
          (card.company?.toLowerCase().contains(query) ?? false) ||
          (card.jobTitle?.toLowerCase().contains(query) ?? false);

      if (!matchesQuery) return false;
      if (_activeFilter == 'Company') {
        return card.company != null && card.company!.isNotEmpty;
      }
      if (_activeFilter == 'Job Title') {
        return card.jobTitle != null && card.jobTitle!.isNotEmpty;
      }
      return true;
    }).toList();

    if (_activeFilter == 'Recently Added') {
      filteredCards.sort((a, b) {
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
    } else if (_activeFilter == 'Company') {
      filteredCards.sort(
        (a, b) => (a.company ?? '').compareTo(b.company ?? ''),
      );
    } else if (_activeFilter == 'Job Title') {
      filteredCards.sort(
        (a, b) => (a.jobTitle ?? '').compareTo(b.jobTitle ?? ''),
      );
    }

    return filteredCards;
  }

  void _setCurrentTab(int index) {
    if (_currentTabIndex == index) return;
    setState(() => _currentTabIndex = index);
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelecting = !_isSelecting;
      if (!_isSelecting) _selectedCardIds.clear();
    });
  }

  void _handleCardTap(int cardId) {
    setState(() {
      final targetSet = _isSelecting ? _selectedCardIds : _expandedCardIds;
      if (targetSet.contains(cardId)) {
        targetSet.remove(cardId);
      } else {
        targetSet.add(cardId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedCardIds.clear();
      _isSelecting = false;
    });
  }

  Future<void> _deleteCard(VisitingCard card) async {
    await ref.read(cardsRepositoryProvider).deleteCard(card.id);
  }

  Future<void> _deleteSelectedCards(List<VisitingCard> allCards) async {
    final repository = ref.read(cardsRepositoryProvider);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    var deleteCount = 0;
    for (final id in _selectedCardIds) {
      await repository.deleteCard(id);
      deleteCount++;
    }

    _clearSelection();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('$deleteCount cards deleted successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareSelectedCards(List<VisitingCard> allCards) {
    final selectedCards = allCards
        .where((card) => _selectedCardIds.contains(card.id))
        .toList();
    if (selectedCards.isEmpty) return;

    if (selectedCards.length == 1) {
      ExportHelper.shareAsVCard(selectedCards.first);
    } else {
      ExportHelper.shareAsCsv(selectedCards);
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _CardsToolbar extends StatelessWidget {
  const _CardsToolbar({
    required this.totalCards,
    required this.isSelecting,
    required this.searchController,
    required this.filters,
    required this.activeFilter,
    required this.onToggleSelection,
    required this.onSearchChanged,
    required this.onFilterSelected,
  });

  final int totalCards;
  final bool isSelecting;
  final TextEditingController searchController;
  final List<String> filters;
  final String activeFilter;
  final VoidCallback onToggleSelection;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardsHeader(
          totalCards: totalCards,
          isSelecting: isSelecting,
          onToggleSelection: onToggleSelection,
        ),
        const SizedBox(height: 16),
        AppSearchField(
          controller: searchController,
          hintText: 'Search names, companies, or titles...',
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 12),
        CardFilterChips(
          filters: filters,
          activeFilter: activeFilter,
          onSelected: onFilterSelected,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({required this.cardsAsync, required this.onExportCards});

  final AsyncValue<List<VisitingCard>> cardsAsync;
  final void Function(List<VisitingCard> cards) onExportCards;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: const Text('Theme Mode'),
          subtitle: const Text('Follow system theme'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.cloud_upload_outlined),
          title: const Text('Export Database'),
          subtitle: const Text('Download all scanned contacts as CSV'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            cardsAsync.whenData((cards) {
              if (cards.isNotEmpty) {
                onExportCards(cards);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No contacts to export.')),
                );
              }
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About CardScan'),
          subtitle: const Text('Version 1.0.0'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => showAboutDialog(context: context),
        ),
      ],
    );
  }
}
