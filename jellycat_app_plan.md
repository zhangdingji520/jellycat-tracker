# Jellycat Collection Tracker - Comprehensive Architecture Plan

**Version:** 1.0  
**Platform:** Flutter (iOS & Android)  
**Architecture Pattern:** Clean Architecture + SOLID Principles  
**State Management:** Riverpod 3.0 (compile-time safe, offline persistence)  
**Database:** SQLite (local) + optional Firebase Firestore (sync)  

---

## 1. Project Overview

### Purpose
A mobile application enabling Jellycat enthusiasts to:
- **Explore** all retired, current, and planned Jellycat releases (900+ items)
- **Track** personal collection status (owned vs. missing from collections)
- **Wishlist** desired Jellycats
- **Value** collection and wishlist in GBP using real-time pricing data

### Key Features
1. **Comprehensive Database** - All Jellycat releases synced periodically
2. **Smart Categorization** - Products grouped by official collections (Bashful, Amuseables, Cordy Roy, etc.)
3. **Collection Tracking** - Mark owned items, see completion % per collection
4. **Wishlist Management** - Add/remove items, sort by price/category
5. **Valuation System** - Estimate total collection/wishlist worth
6. **Branding** - Jellycat color palette, typography, design language
7. **Offline-First** - Full functionality without internet (data syncs when available)
8. **Cross-Platform** - Native performance on iOS and Android

---

## 2. Architecture Overview

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                 │
│  (Screens, Widgets, State Management - Riverpod)   │
├─────────────────────────────────────────────────────┤
│                   DOMAIN LAYER                       │
│  (Entities, Use Cases, Repository Interfaces)      │
├─────────────────────────────────────────────────────┤
│                   DATA LAYER                         │
│  (Repositories, Data Sources, Models)              │
├─────────────────────────────────────────────────────┤
│              PLATFORM & INFRASTRUCTURE              │
│  (Database, Networking, Firebase, Platform APIs)   │
└─────────────────────────────────────────────────────┘
```

### Folder Structure

```
jellycat_app/
├── lib/
│   ├── main.dart                           # App entry point, DI setup
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart            # Jellycat brand colors
│   │   │   ├── app_strings.dart           # String constants
│   │   │   └── app_text_styles.dart       # Typography
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # Material 3 + Jellycat branding
│   │   │   └── dark_theme.dart
│   │   ├── utils/
│   │   │   ├── logger.dart                # Logging utility
│   │   │   ├── date_formatter.dart
│   │   │   ├── currency_formatter.dart
│   │   │   └── validators.dart
│   │   └── error/
│   │       ├── failures.dart              # Custom exception classes
│   │       └── error_handler.dart
│   │
│   ├── features/
│   │   │
│   │   ├── catalog/                       # Feature: Browse all Jellycats
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── jellycat_local_data_source.dart    (SQLite)
│   │   │   │   │   ├── jellycat_remote_data_source.dart   (API/Web Scrape)
│   │   │   │   │   └── jellycat_sync_service.dart         (Periodic sync)
│   │   │   │   ├── models/
│   │   │   │   │   ├── jellycat_model.dart                (JSON serializable)
│   │   │   │   │   ├── collection_model.dart
│   │   │   │   │   └── price_history_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── jellycat_repository_impl.dart      (Data access logic)
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── jellycat_entity.dart
│   │   │   │   │   ├── collection_entity.dart
│   │   │   │   │   └── price_point_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── jellycat_repository.dart           (Interface/Contract)
│   │   │   │   └── usecases/
│   │   │   │       ├── get_all_jellycats_usecase.dart
│   │   │   │       ├── search_jellycats_usecase.dart
│   │   │   │       ├── get_collection_by_name_usecase.dart
│   │   │   │       └── sync_jellycats_usecase.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── providers/               # Riverpod providers
│   │   │       │   ├── catalog_providers.dart
│   │   │       │   ├── search_providers.dart
│   │   │       │   └── filter_providers.dart
│   │   │       ├── controllers/             # Business logic (not UI state)
│   │   │       │   ├── catalog_controller.dart
│   │   │       │   └── sync_controller.dart
│   │   │       ├── widgets/
│   │   │       │   ├── jellycat_card.dart
│   │   │       │   ├── collection_list_item.dart
│   │   │       │   ├── price_badge.dart
│   │   │       │   └── collection_header.dart
│   │   │       ├── pages/
│   │   │       │   ├── catalog_page.dart
│   │   │       │   ├── collection_detail_page.dart
│   │   │       │   └── jellycat_detail_page.dart
│   │   │       └── state/
│   │   │           └── catalog_state.dart   # UI state models
│   │   │
│   │   ├── collection/                     # Feature: Track owned Jellycats
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── user_collection_local_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── user_jellycat_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── user_collection_repository_impl.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user_jellycat_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── user_collection_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── add_to_collection_usecase.dart
│   │   │   │       ├── remove_from_collection_usecase.dart
│   │   │   │       ├── get_user_collection_usecase.dart
│   │   │   │       ├── get_collection_stats_usecase.dart
│   │   │   │       └── calculate_collection_value_usecase.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── collection_providers.dart
│   │   │       ├── controllers/
│   │   │       │   └── collection_controller.dart
│   │   │       ├── widgets/
│   │   │       │   ├── collection_progress_card.dart
│   │   │       │   ├── owned_item_list.dart
│   │   │       │   └── value_summary_widget.dart
│   │   │       ├── pages/
│   │   │       │   ├── my_collection_page.dart
│   │   │       │   └── collection_stats_page.dart
│   │   │       └── state/
│   │   │           └── collection_state.dart
│   │   │
│   │   └── wishlist/                      # Feature: Manage wishlist
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── wishlist_local_data_source.dart
│   │       │   ├── models/
│   │       │   │   └── wishlist_item_model.dart
│   │       │   └── repositories/
│   │       │       └── wishlist_repository_impl.dart
│   │       │
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── wishlist_item_entity.dart
│   │       │   ├── repositories/
│   │       │   │   └── wishlist_repository.dart
│   │       │   └── usecases/
│   │       │       ├── add_to_wishlist_usecase.dart
│   │       │       ├── remove_from_wishlist_usecase.dart
│   │       │       ├── get_wishlist_usecase.dart
│   │       │       └── calculate_wishlist_value_usecase.dart
│   │       │
│   │       └── presentation/
│   │           ├── providers/
│   │           │   └── wishlist_providers.dart
│   │           ├── controllers/
│   │           │   └── wishlist_controller.dart
│   │           ├── widgets/
│   │           │   ├── wishlist_item_card.dart
│   │           │   └── wishlist_value_summary.dart
│   │           ├── pages/
│   │           │   └── wishlist_page.dart
│   │           └── state/
│   │               └── wishlist_state.dart
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── app_bar_custom.dart
│   │   │   ├── bottom_nav_bar.dart
│   │   │   ├── loading_indicator.dart
│   │   │   ├── error_widget.dart
│   │   │   └── empty_state_widget.dart
│   │   │
│   │   ├── providers/
│   │   │   ├── app_providers.dart          # Global DI container
│   │   │   └── riverpod_logger.dart        # Riverpod debugging
│   │   │
│   │   └── models/
│   │       └── pagination_model.dart
│   │
│   └── services/
│       ├── database/
│       │   ├── sqlite_service.dart
│       │   ├── database_schema.dart
│       │   └── database_migrations.dart
│       │
│       ├── api/
│       │   ├── api_client.dart
│       │   ├── jellycat_api_service.dart
│       │   └── scrapers/
│       │       └── jellycat_web_scraper.dart  (Data source for catalog)
│       │
│       ├── analytics/
│       │   └── analytics_service.dart
│       │
│       └── sync/
│           ├── sync_engine.dart
│           └── conflict_resolver.dart
│
├── test/
│   ├── unit/
│   │   ├── domain/usecases/
│   │   ├── data/repositories/
│   │   └── presentation/controllers/
│   ├── widget/
│   └── integration/
│
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

---

## 3. Technology Stack

### Core Dependencies

```yaml
# State Management & DI
riverpod: ^3.0.0          # Compile-time safe, provider pattern
riverpod_generator: ^3.0.0
flutter_riverpod: ^3.0.0
go_router: ^13.0.0        # Type-safe navigation with Riverpod

# Database & Local Storage
sqflite: ^2.3.0           # SQLite wrapper
sqflite_common_ffi: ^2.3.0 # Desktop support (testing)
path_provider: ^2.1.0
isar: ^4.0.0              # Optional: faster alternative to SQLite

# Networking & Data
dio: ^5.4.0               # HTTP client with interceptors
internet_connection_checker_plus: ^2.4.0

# JSON & Data Serialization
json_serializable: ^6.7.0
json_annotation: ^4.8.0
freezed: ^2.4.0           # Immutable models (optional but recommended)
freezed_annotation: ^2.4.0

# UI & Design
flutter_staggered_grid_view: ^0.7.0  # For flexible grid layouts
cached_network_image: ^3.3.0         # Image caching
shimmer: ^3.0.0                      # Skeleton loading
intl: ^0.19.0                        # Internationalization & formatting

# Firebase (Optional: for cloud sync)
firebase_core: ^27.0.0
cloud_firestore: ^5.0.0
firebase_auth: ^5.0.0

# Logging & Debugging
logger: ^2.1.0
fpdart: ^1.1.0            # Functional programming utilities

# Testing
mocktail: ^1.0.0
bloc_test: ^9.1.0
riverpod_test: ^2.0.0
```

### Version Targets
- **Min SDK (Android):** API 21 (5.0)
- **Min Deployment (iOS):** 12.0
- **Dart:** 3.4+

---

## 4. SOLID Principles Implementation

### 1. Single Responsibility Principle (SRP)

Each class has ONE reason to change:

```dart
// ✅ GOOD: Single responsibility
abstract class JellycatRepository {
  Future<List<JellycatEntity>> getAllJellycats();
}

class JellycatRepositoryImpl implements JellycatRepository {
  final JellycatRemoteDataSource remoteDataSource;
  final JellycatLocalDataSource localDataSource;
  
  JellycatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<List<JellycatEntity>> getAllJellycats() async {
    // Repository only knows about fetching; not UI, not DB schemas
  }
}

// ✅ GOOD: Separate data access concerns
abstract class JellycatRemoteDataSource {
  Future<List<JellycatModel>> fetchAllJellycats();
}

abstract class JellycatLocalDataSource {
  Future<List<JellycatModel>> getCachedJellycats();
  Future<void> cacheJellycats(List<JellycatModel> items);
}

// ✅ GOOD: Use cases are focused
class GetAllJellycatsUseCase {
  final JellycatRepository repository;
  
  GetAllJellycatsUseCase({required this.repository});
  
  Future<Either<Failure, List<JellycatEntity>>> call() async {
    return await repository.getAllJellycats();
  }
}
```

**Application:**
- **Widgets** → UI rendering only (no business logic)
- **Controllers/Providers** → State management only
- **UseCases** → Single business operation
- **Repositories** → Data orchestration (not retrieval)
- **DataSources** → Single data medium (DB, API, cache)

---

### 2. Open/Closed Principle (OCP)

Open for extension, closed for modification:

```dart
// ✅ GOOD: Abstract interface allows new data sources without modifying existing code
abstract class PriceDataSource {
  Future<PricePoint> fetchPrice(String jellycatId);
}

class OfficialWebsitePriceSource implements PriceDataSource {
  @override
  Future<PricePoint> fetchPrice(String jellycatId) async {
    // Scrape official site
  }
}

class RetailerAPIPriceSource implements PriceDataSource {
  @override
  Future<PricePoint> fetchPrice(String jellycatId) async {
    // Call retailer API
  }
}

// No existing code changed; new sources extend functionality
class AveragePriceRepository {
  final List<PriceDataSource> sources;
  
  AveragePriceRepository({required this.sources});
  
  Future<double> getAveragePrice(String jellycatId) async {
    final prices = await Future.wait(
      sources.map((source) => source.fetchPrice(jellycatId)),
    );
    return prices.map((p) => p.gbp).fold(0, (a, b) => a + b) / prices.length;
  }
}
```

**Application:**
- Define abstract classes/interfaces for extension points
- Inject implementations at composition root (main.dart)
- Never switch on concrete types in business logic

---

### 3. Liskov Substitution Principle (LSP)

Subtypes must be substitutable for base types:

```dart
// ✅ GOOD: Both implementations behave identically from the caller's perspective
abstract class JellycatDataSource {
  Future<List<JellycatModel>> fetch();
}

class LocalJellycatDataSource implements JellycatDataSource {
  @override
  Future<List<JellycatModel>> fetch() async {
    // Return instant data from SQLite
  }
}

class RemoteJellycatDataSource implements JellycatDataSource {
  @override
  Future<List<JellycatModel>> fetch() async {
    // Fetch from API, return same structure
  }
}

// Repository doesn't care which implementation—behavior is identical
class JellycatRepositoryImpl {
  final JellycatDataSource _dataSource;
  
  JellycatRepositoryImpl({required JellycatDataSource dataSource})
    : _dataSource = dataSource;
  
  Future<List<JellycatEntity>> getJellycats() async {
    // Works with local OR remote without changes
    final models = await _dataSource.fetch();
    return models.map((m) => m.toDomain()).toList();
  }
}
```

---

### 4. Interface Segregation Principle (ISP)

Clients depend only on methods they use:

```dart
// ❌ BAD: Bloated interface
abstract class UserService {
  Future<void> login(String email, String password);
  Future<void> logout();
  Future<void> updateProfile(UserProfile profile);
  Future<void> deleteAccount();
  Future<List<User>> searchUsers(String query);
  Future<void> reportUser(String userId);
}

// ✅ GOOD: Segregated interfaces
abstract class AuthenticationService {
  Future<void> login(String email, String password);
  Future<void> logout();
}

abstract class ProfileService {
  Future<void> updateProfile(UserProfile profile);
  Future<void> deleteAccount();
}

abstract class UserSearchService {
  Future<List<User>> searchUsers(String query);
}

abstract class ModerationService {
  Future<void> reportUser(String userId);
}

// Controllers depend only on what they need
class LoginController {
  final AuthenticationService authService;
  LoginController({required this.authService});
}

class ProfileController {
  final ProfileService profileService;
  ProfileController({required this.profileService});
}
```

**Application for Jellycat:**
```dart
// ✅ Don't create monolithic service
abstract class JellycatManagementService {
  Future<void> addToCollection(String jellycatId);
  Future<void> removeFromCollection(String jellycatId);
  Future<void> addToWishlist(String jellycatId);
  // ... 20 more methods
}

// ✅ Instead, segregate by domain
abstract class CollectionService {
  Future<void> add(String jellycatId);
  Future<void> remove(String jellycatId);
  Future<List<String>> getAll();
}

abstract class WishlistService {
  Future<void> add(String jellycatId);
  Future<void> remove(String jellycatId);
  Future<List<String>> getAll();
}
```

---

### 5. Dependency Inversion Principle (DIP)

Depend on abstractions, not concretions:

```dart
// ❌ BAD: Concrete dependency
class JellycatController {
  late SQLiteDatabase database; // Direct concrete dependency
  
  JellycatController() {
    database = SQLiteDatabase(); // Hard to test, tightly coupled
  }
}

// ✅ GOOD: Abstract dependency via constructor injection
abstract class JellycatDatabase {
  Future<List<JellycatModel>> getAll();
  Future<void> save(JellycatModel model);
}

class SQLiteJellycatDatabase implements JellycatDatabase {
  // Implementation details
}

class JellycatController {
  final JellycatDatabase database;
  
  JellycatController({required this.database}); // Injected
}

// ✅ Riverpod providers manage DI at composition root
@riverpod
JellycatDatabase jellycatDatabase(JellycatDatabaseRef ref) {
  return SQLiteJellycatDatabase();
}

@riverpod
JellycatController jellycatController(JellycatControllerRef ref) {
  return JellycatController(
    database: ref.watch(jellycatDatabaseProvider),
  );
}
```

---

## 5. State Management: Riverpod 3.0

### Why Riverpod over Provider/BLoC?

| Feature | Riverpod | Provider | BLoC |
|---------|----------|----------|------|
| **Compile-Time Safety** | ✅ Yes | ❌ Runtime | ❌ Runtime |
| **Boilerplate** | Low | Medium | High |
| **Offline Persistence** | ✅ Built-in | Via hooks | Manual |
| **Testing** | Easy (no BuildContext) | Medium | Medium |
| **Learning Curve** | Moderate | Easy | Steep |
| **2025 Recommendation** | ⭐ Best | Good | Enterprise |

### Provider Architecture

```dart
// ✅ GOOD: Simple data provider
@riverpod
Future<List<JellycatEntity>> getAllJellycats(
  GetAllJellycatsRef ref,
) async {
  final repository = ref.watch(jellycatRepositoryProvider);
  return repository.getAllJellycats();
}

// ✅ GOOD: Filtered provider (depends on other providers)
@riverpod
Future<List<JellycatEntity>> filterJellycats(
  FilterJellycatsRef ref, {
  required String collectionName,
}) async {
  final jellycats = await ref.watch(getAllJellycatsProvider.future);
  return jellycats
    .where((j) => j.collectionName == collectionName)
    .toList();
}

// ✅ GOOD: State management provider
@riverpod
class CollectionNotifier extends _$CollectionNotifier {
  @override
  Future<List<String>> build() async {
    final repository = ref.watch(userCollectionRepositoryProvider);
    return repository.getUserCollection();
  }
  
  Future<void> addJellycat(String jellycatId) async {
    final repository = ref.watch(userCollectionRepositoryProvider);
    await repository.add(jellycatId);
    ref.invalidateSelf(); // Rebuild this provider
  }
  
  Future<void> removeJellycat(String jellycatId) async {
    final repository = ref.watch(userCollectionRepositoryProvider);
    await repository.remove(jellycatId);
    ref.invalidateSelf();
  }
}

@riverpod
CollectionNotifier collection(CollectionRef ref) {
  return CollectionNotifier(ref: ref);
}

// ✅ GOOD: Computed value provider
@riverpod
Future<double> collectionValue(CollectionValueRef ref) async {
  final ownedIds = await ref.watch(collectionProvider.future);
  final jellycats = await ref.watch(getAllJellycatsProvider.future);
  
  return ownedIds.fold(0.0, (sum, id) {
    final jellycat = jellycats.firstWhere((j) => j.id == id);
    return sum + (jellycat.price ?? 0);
  });
}
```

### Using Providers in Widgets

```dart
// ✅ GOOD: Riverpod widget (no BuildContext needed for state)
class JellycatCatalogPage extends ConsumerWidget {
  const JellycatCatalogPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jellycatsAsync = ref.watch(getAllJellycatsProvider);
    
    return jellycatsAsync.when(
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorWidget(error: error),
      data: (jellycats) => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: jellycats.length,
        itemBuilder: (context, index) {
          return JellycatCard(jellycat: jellycats[index]);
        },
      ),
    );
  }
}

// ✅ GOOD: Responding to state changes
class MyCollectionPage extends ConsumerWidget {
  const MyCollectionPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(collectionProvider);
    final valueAsync = ref.watch(collectionValueProvider);
    
    return collectionAsync.when(
      data: (ownedIds) => Column(
        children: [
          Text('Owned: ${ownedIds.length} Jellycats'),
          valueAsync.when(
            data: (value) => Text('Worth: £${value.toStringAsFixed(2)}'),
            loading: () => const CircularProgressIndicator(),
            error: (e, st) => Text('Error: $e'),
          ),
        ],
      ),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorWidget(error: error),
    );
  }
}
```

---

## 6. Data Models & Entity Mapping

### Entity (Domain Layer)

```dart
// lib/features/catalog/domain/entities/jellycat_entity.dart

@freezed
class JellycatEntity with _$JellycatEntity {
  const factory JellycatEntity({
    required String id,                    // Unique identifier (batch code)
    required String name,
    required String collectionName,        // e.g., "Bashful", "Amuseables"
    required String? description,
    required String? imageUrl,
    required List<String> colors,          // Color variants available
    required List<String> sizes,           // Size options (Small, Medium, Big, etc.)
    required double? currentPrice,         // GBP
    required List<PricePoint> priceHistory,
    required DateTime releasedDate,
    required DateTime? retiredDate,        // Null if still available
    required bool isNew,                   // Part of current collection?
    required bool isRetired,
    required bool isPlanned,
    required int estimatedQuantity,        // Units sold estimate (for valuation)
  }) = _JellycatEntity;
}

@freezed
class CollectionEntity with _$CollectionEntity {
  const factory CollectionEntity({
    required String name,
    required String? description,
    required String? imageUrl,
    required List<String> jellycatIds,
    required int totalCount,
  }) = _CollectionEntity;
}

@freezed
class PricePoint with _$PricePoint {
  const factory PricePoint({
    required double gbp,
    required DateTime date,
    required String? source,               // e.g., "Official", "Retailer: Maison White"
  }) = _PricePoint;
}
```

### Model (Data Layer)

```dart
// lib/features/catalog/data/models/jellycat_model.dart

@freezed
class JellycatModel with _$JellycatModel {
  const factory JellycatModel({
    required String id,
    required String name,
    required String collectionName,
    required String? description,
    required String? imageUrl,
    required List<String> colors,
    required List<String> sizes,
    required double? currentPrice,
    required List<PricePointModel> priceHistory,
    required DateTime releasedDate,
    required DateTime? retiredDate,
    required bool isNew,
    required bool isRetired,
    required bool isPlanned,
    required int estimatedQuantity,
  }) = _JellycatModel;
  
  factory JellycatModel.fromJson(Map<String, dynamic> json) =>
    _$JellycatModelFromJson(json);
  
  factory JellycatModel.fromSqliteMap(Map<String, dynamic> map) {
    return JellycatModel(
      id: map['id'] as String,
      name: map['name'] as String,
      // ... map database columns
      priceHistory: [], // Fetched separately
    );
  }
  
  Map<String, dynamic> toSqliteMap() {
    return {
      'id': id,
      'name': name,
      'collectionName': collectionName,
      'description': description,
      'imageUrl': imageUrl,
      'colors': colors.join(','),
      'sizes': sizes.join(','),
      'currentPrice': currentPrice,
      'releasedDate': releasedDate.toIso8601String(),
      'retiredDate': retiredDate?.toIso8601String(),
      'isNew': isNew ? 1 : 0,
      'isRetired': isRetired ? 1 : 0,
      'isPlanned': isPlanned ? 1 : 0,
      'estimatedQuantity': estimatedQuantity,
    };
  }
  
  JellycatEntity toDomain() {
    return JellycatEntity(
      id: id,
      name: name,
      collectionName: collectionName,
      description: description,
      imageUrl: imageUrl,
      colors: colors,
      sizes: sizes,
      currentPrice: currentPrice,
      priceHistory: priceHistory.map((p) => p.toDomain()).toList(),
      releasedDate: releasedDate,
      retiredDate: retiredDate,
      isNew: isNew,
      isRetired: isRetired,
      isPlanned: isPlanned,
      estimatedQuantity: estimatedQuantity,
    );
  }
}
```

---

## 7. Data Sources & Database Schema

### SQLite Schema

```sql
-- Jellycats table
CREATE TABLE jellycats (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  collection_name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  colors TEXT NOT NULL,           -- CSV: "Cream,Blush,Hot Pink"
  sizes TEXT NOT NULL,            -- CSV: "Small,Medium,Big"
  current_price REAL,
  released_date DATETIME NOT NULL,
  retired_date DATETIME,
  is_new INTEGER NOT NULL DEFAULT 0,
  is_retired INTEGER NOT NULL DEFAULT 0,
  is_planned INTEGER NOT NULL DEFAULT 0,
  estimated_quantity INTEGER DEFAULT 0,
  synced_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(id)
);

-- Price history table
CREATE TABLE price_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  jellycat_id TEXT NOT NULL,
  price REAL NOT NULL,
  source TEXT,                    -- "Official", "Maison White", etc.
  recorded_date DATETIME NOT NULL,
  FOREIGN KEY(jellycat_id) REFERENCES jellycats(id) ON DELETE CASCADE,
  UNIQUE(jellycat_id, price, recorded_date)
);

-- User's collection (owned Jellycats)
CREATE TABLE user_collection (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  jellycat_id TEXT NOT NULL UNIQUE,
  date_acquired DATETIME DEFAULT CURRENT_TIMESTAMP,
  condition TEXT DEFAULT 'Mint',  -- Mint, Good, Fair, Poor
  FOREIGN KEY(jellycat_id) REFERENCES jellycats(id) ON DELETE CASCADE
);

-- Wishlist
CREATE TABLE wishlist (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  jellycat_id TEXT NOT NULL UNIQUE,
  date_added DATETIME DEFAULT CURRENT_TIMESTAMP,
  priority INTEGER DEFAULT 5,     -- 1=Urgent, 5=Nice to have
  notes TEXT,
  FOREIGN KEY(jellycat_id) REFERENCES jellycats(id) ON DELETE CASCADE
);

-- Collections (groupings)
CREATE TABLE collections (
  name TEXT PRIMARY KEY,
  description TEXT,
  image_url TEXT,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Collection members
CREATE TABLE collection_members (
  collection_name TEXT NOT NULL,
  jellycat_id TEXT NOT NULL,
  position INTEGER,
  PRIMARY KEY(collection_name, jellycat_id),
  FOREIGN KEY(collection_name) REFERENCES collections(name),
  FOREIGN KEY(jellycat_id) REFERENCES jellycats(id)
);

-- Indexes for performance
CREATE INDEX idx_jellycats_collection ON jellycats(collection_name);
CREATE INDEX idx_jellycats_released_date ON jellycats(released_date);
CREATE INDEX idx_price_history_jellycat_id ON price_history(jellycat_id);
CREATE INDEX idx_user_collection_date ON user_collection(date_acquired);
```

### Data Source Implementation

```dart
// lib/features/catalog/data/datasources/jellycat_local_data_source.dart

abstract class JellycatLocalDataSource {
  Future<List<JellycatModel>> getAll();
  Future<JellycatModel?> getById(String id);
  Future<List<JellycatModel>> getByCollection(String collectionName);
  Future<void> saveAll(List<JellycatModel> jellycats);
  Future<void> clearAll();
  Future<DateTime?> getLastSyncTime();
}

class JellycatLocalDataSourceImpl implements JellycatLocalDataSource {
  final SQLiteDatabase database;
  
  JellycatLocalDataSourceImpl({required this.database});
  
  @override
  Future<List<JellycatModel>> getAll() async {
    final maps = await database.query('jellycats');
    return maps.map((map) => JellycatModel.fromSqliteMap(map)).toList();
  }
  
  @override
  Future<void> saveAll(List<JellycatModel> jellycats) async {
    for (final jellycat in jellycats) {
      await database.insert(
        'jellycats',
        jellycat.toSqliteMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
  
  // ... other methods
}

// lib/features/catalog/data/datasources/jellycat_remote_data_source.dart

abstract class JellycatRemoteDataSource {
  Future<List<JellycatModel>> fetchAllJellycats();
}

class JellycatRemoteDataSourceImpl implements JellycatRemoteDataSource {
  final Dio dio;
  
  JellycatRemoteDataSourceImpl({required this.dio});
  
  @override
  Future<List<JellycatModel>> fetchAllJellycats() async {
    try {
      // Option 1: If Jellycat provides an API
      final response = await dio.get('https://api.jellycat.com/products');
      final data = response.data as List;
      return data.map((item) => JellycatModel.fromJson(item)).toList();
    } catch (e) {
      // Option 2: Web scraping from official retailers (fallback)
      return await _scrapeJellycats();
    }
  }
  
  Future<List<JellycatModel>> _scrapeJellycats() async {
    // Use Puppeteer or Selenium via Dart isolates
    // Or maintain a curated JSON file updated weekly
    // See: jellycat-scraper service
  }
}
```

---

## 8. Branding & Visual Design

### Jellycat Brand Colors

```dart
// lib/core/constants/app_colors.dart

class JellycatColors {
  // Primary palette
  static const Color primaryBrand = Color(0xFF8B4789);      // Jellycat purple
  static const Color secondaryBrand = Color(0xFF4A90A4);    // Jellycat teal
  static const Color accentPink = Color(0xFFF28E87);        // Soft pink
  static const Color accentCream = Color(0xFFFDEDD8);       // Jellycat cream
  
  // Semantic colors
  static const Color success = Color(0xFF2ECC71);           // Owned
  static const Color warning = Color(0xFFF39C12);           // Wishlist
  static const Color error = Color(0xFFE74C3C);             // Retired
  static const Color info = Color(0xFF3498DB);              // New/Planned
  
  // Neutral palette
  static const Color dark = Color(0xFF2C2C2C);
  static const Color light = Color(0xFFF5F5F5);
  static const Color border = Color(0xFFE0E0E0);
}
```

### Typography

```dart
// lib/core/constants/app_text_styles.dart

class JellycatTextStyles {
  static const headlineXL = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  
  static const headlineL = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const bodyLarge = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );
  
  static const labelSmall = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
}
```

### Theme Implementation

```dart
// lib/core/theme/app_theme.dart

class JellycatTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: JellycatColors.primaryBrand,
        brightness: Brightness.light,
      ),
      textTheme: _buildTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: JellycatColors.primaryBrand,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: JellycatColors.primaryBrand,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: JellycatTextStyles.headlineXL,
      displayMedium: JellycatTextStyles.headlineL,
      bodyLarge: JellycatTextStyles.bodyLarge,
      labelSmall: JellycatTextStyles.labelSmall,
    );
  }
}
```

---

## 9. Sync Strategy

### Background Sync Engine

```dart
// lib/services/sync/sync_engine.dart

class SyncEngine {
  static const Duration _syncInterval = Duration(hours: 6);
  
  final JellycatRemoteDataSource remoteDataSource;
  final JellycatLocalDataSource localDataSource;
  final ConnectivityService connectivity;
  
  Timer? _syncTimer;
  
  void startPeriodicSync() {
    _syncTimer = Timer.periodic(_syncInterval, (_) => _performSync());
  }
  
  Future<void> _performSync() async {
    if (!await connectivity.isConnected()) return;
    
    try {
      final remote = await remoteDataSource.fetchAllJellycats();
      await localDataSource.saveAll(remote);
      
      // Log successful sync
      logger.i('Synced ${remote.length} Jellycats');
    } catch (e) {
      logger.e('Sync failed', error: e);
      // User still has local data; offline-first approach
    }
  }
  
  void dispose() {
    _syncTimer?.cancel();
  }
}
```

---

## 10. Testing Strategy

### Unit Testing Example

```dart
// test/unit/domain/usecases/get_all_jellycats_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockJellycatRepository extends Mock implements JellycatRepository {}

void main() {
  group('GetAllJellycatsUseCase', () {
    late GetAllJellycatsUseCase useCase;
    late MockJellycatRepository mockRepository;
    
    setUp(() {
      mockRepository = MockJellycatRepository();
      useCase = GetAllJellycatsUseCase(repository: mockRepository);
    });
    
    test('should return list of jellycats when repository succeeds', () async {
      // Arrange
      final mockJellycats = [
        JellycatEntity(
          id: '1',
          name: 'Bashful Bunny',
          // ...
        ),
      ];
      when(() => mockRepository.getAllJellycats())
        .thenAnswer((_) async => mockJellycats);
      
      // Act
      final result = await useCase();
      
      // Assert
      expect(result, mockJellycats);
      verify(() => mockRepository.getAllJellycats()).called(1);
    });
  });
}
```

---

## 11. Key Implementation Checklist

### Phase 1: Foundation
- [ ] Project setup (pubspec.yaml, DI container)
- [ ] Database schema & SQLite integration
- [ ] Core theme & branding
- [ ] Base entity/model classes with Freezed

### Phase 2: Data Layer
- [ ] JellycatRemoteDataSource (web scraper or API)
- [ ] JellycatLocalDataSource (SQLite)
- [ ] JellycatRepository implementation
- [ ] Price history tracking

### Phase 3: Domain Layer
- [ ] Use cases (GetAllJellycats, FilterJellycats, etc.)
- [ ] Domain entities
- [ ] Repository interfaces

### Phase 4: Presentation Layer
- [ ] Riverpod providers & state management
- [ ] Catalog page (grid of Jellycats)
- [ ] Collection detail page
- [ ] Jellycat detail page

### Phase 5: Features
- [ ] Collection tracker (add/remove owned)
- [ ] Wishlist management
- [ ] Collection statistics & valuation
- [ ] Search & filtering

### Phase 6: Polish
- [ ] Offline-first sync
- [ ] Error handling & logging
- [ ] Unit & widget tests
- [ ] Performance optimization

---

## 12. Offline-First Data Strategy

**Key Principle:** Users can browse, track, and manage their collection WITHOUT internet.

1. **Initial Sync** - Download full catalog on first launch (50-100 MB)
2. **Periodic Sync** - Every 6 hours if connected (incremental updates)
3. **Local Modifications** - All collection/wishlist changes stored locally immediately
4. **Conflict Resolution** - If user modifies offline then syncs, local changes win
5. **Cache Invalidation** - When data > 24 hours old, mark stale but still display

---

## 13. Performance Considerations

- **Pagination:** Load 50 items at a time for catalog
- **Image Caching:** Use `CachedNetworkImage` with 100 MB cache
- **Database Indexing:** Index on `collection_name`, `released_date` for fast queries
- **Provider Caching:** Use `.family` modifiers for filtered lists
- **Grid Optimization:** Use `RepaintBoundary` for grid items

---

## 14. Deployment Checklist

### Android
- [ ] Sign APK with release key
- [ ] Test on Android 5.0+ devices
- [ ] Proguard rules for release build
- [ ] Google Play Console submission

### iOS
- [ ] Create provisioning profiles
- [ ] Configure code signing
- [ ] Test on iOS 12.0+ devices
- [ ] App Store Connect submission

---

## 15. Future Enhancements

1. **Cloud Sync** - Firebase Firestore for multi-device sync
2. **Social Features** - Share collections with friends
3. **Market Data** - Real-time secondary market prices
4. **OCR Recognition** - Photograph Jellycat to ID & add to collection
5. **AR Preview** - Visualize Jellycat in your room
6. **Notifications** - Alert when wishlist items restock
7. **Duplicate Detection** - Find variants/sizes you own

---

## Summary

This architecture provides:

✅ **SOLID Principles** - Maintainable, testable, extensible codebase  
✅ **Offline-First** - Full functionality without internet  
✅ **Type Safety** - Compile-time checked Riverpod providers  
✅ **Scalability** - Feature-based folder structure for growth  
✅ **Branding** - Jellycat colors, typography, design language  
✅ **Performance** - Database indexing, image caching, pagination  
✅ **Testing** - Unit, widget, and integration test structure  

The app will track your Jellycat collection from day one, estimate its worth, and help you discover which plushies you're missing from each collection.

---

**Next Steps:**
1. Set up Flutter project with dependencies
2. Create SQLite schema and migrations
3. Implement data sources (prioritize web scraper)
4. Build Riverpod providers for catalog
5. Create UI for catalog browsing & collection tracking
6. Add Jellycat branding throughout

