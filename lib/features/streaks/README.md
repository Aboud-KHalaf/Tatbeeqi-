# User Streaks Feature

A complete Flutter implementation of a learning streak system similar to Duolingo, following Clean Architecture principles with Material 3 design.

## 🏗️ Architecture

### Domain Layer
- **Entity**: `UserStreak` - Core business logic with streak validation methods
- **Repository Interface**: `StreaksRepository` - Abstract contract for data operations
- **Use Cases**: 
  - `GetUserStreak` - Fetch user's current streak data
  - `UpdateStreakOnLessonComplete` - Update streak when lesson completed

### Data Layer
- **Model**: `UserStreakModel` - Data transfer object with JSON serialization
- **Remote Data Source**: `StreaksRemoteDataSourceImpl` - Supabase integration
- **Repository Implementation**: `StreaksRepositoryImpl` - Concrete repository with network handling

### Presentation Layer
- **Cubit**: `StreaksCubit` - State management with BLoC pattern
- **States**: Loading, Loaded, Error, Updating states
- **Views**: Modern Material 3 UI with animations and calendar view

## 🎨 UI Components

### Main Screen (`StreaksView`)
- Animated header with gradient background
- Pull-to-refresh functionality
- Error handling with retry mechanism
- Loading states with professional indicators

### Custom Widgets
1. **StreakCard** - Animated cards showing current/longest streak
2. **StreakCalendar** - 7-day calendar view with completion indicators
3. **StreakMotivationCard** - Dynamic motivational messages
4. **StreakNavigationButton** - Compact navigation widget for other screens

## 🔥 Key Features

### Streak Logic
- **Active Streak**: Completed today or yesterday
- **Streak Continuation**: Must complete lesson daily to maintain
- **Streak Reset**: Breaks if more than 1 day gap
- **Longest Streak Tracking**: Automatically updates personal best

### Visual Indicators
- **Fire Icons**: Animated flame icons for active streaks
- **Calendar Dots**: Green dots for completed days
- **Progress Animation**: Smooth number counting animations
- **Pulse Effects**: Attention-grabbing animations for active streaks

### Motivational System
- Dynamic messages based on streak status
- Encouragement for streak maintenance
- Celebration for achievements
- Gentle reminders for inactive users

## 🗄️ Database Schema

### Tables Required
```sql
-- User streaks table
CREATE TABLE user_streaks (
  user_id UUID PRIMARY KEY REFERENCES profiles(id),
  current_streak INTEGER NOT NULL DEFAULT 0,
  longest_streak INTEGER NOT NULL DEFAULT 0,
  last_completed_date DATE
);

-- Lesson progress table (existing)
CREATE TABLE lesson_progress (
  user_id UUID NOT NULL REFERENCES profiles(id),
  lesson_id INTEGER NOT NULL REFERENCES lessons(id),
  is_completed BOOLEAN NOT NULL DEFAULT false,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (user_id, lesson_id)
);
```

### Database Function
The `update_user_streak(UUID)` function handles all streak logic:
- Checks if lesson completed today
- Continues or resets streak based on last completion date
- Updates longest streak if current exceeds it
- Atomic operation to prevent race conditions

## 🔧 Integration

### Dependency Injection
```dart
// Added to service locator
initStreaksDependencies(sl);
```

### Routing
```dart
// Route configuration
GoRoute(
  path: '/streaks',
  builder: (context, state) => const StreaksPage(),
)
```

### Usage Example
```dart
// Navigation to streaks
context.push(AppRoutes.streaksPath);

// Update streak on lesson completion
await context.read<StreaksCubit>().updateStreak(userId);

// Navigation button widget
StreakNavigationButton(
  currentStreak: streak.currentStreak,
  isStreakActive: streak.isStreakActive,
)
```

## 🎯 User Experience

### Material 3 Design
- Consistent color scheme usage
- Modern rounded corners and shadows
- Smooth animations and transitions
- Proper elevation and depth

### Accessibility
- Haptic feedback for interactions
- Proper focus management
- Screen reader support
- High contrast support

### Performance
- Lazy loading with GetIt
- Efficient state management
- Optimized animations
- Memory leak prevention

## 🚀 Getting Started

1. **Database Setup**: Execute the SQL function in Supabase
2. **Dependencies**: Ensure all packages are installed
3. **Integration**: Add streak updates to lesson completion flow
4. **Navigation**: Add streak button to main navigation
5. **Testing**: Test with different streak scenarios

## 📱 Screenshots Features

- **Current Streak Card**: Large animated number with fire icon
- **Longest Streak Card**: Trophy icon with personal best
- **7-Day Calendar**: Visual progress with completion dots
- **Motivation Messages**: Context-aware encouragement
- **Loading States**: Professional loading indicators
- **Error Handling**: User-friendly error messages with retry

The implementation provides a complete, production-ready streak system that encourages daily learning through gamification and visual feedback.
