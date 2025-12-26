# Contributing to Snake App

First off, thank you for considering contributing to Snake App! It's people like you that make Snake App such a great game.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Development Setup](#development-setup)
4. [How to Contribute](#how-to-contribute)
5. [Coding Standards](#coding-standards)
6. [Commit Guidelines](#commit-guidelines)
7. [Pull Request Process](#pull-request-process)
8. [Testing Guidelines](#testing-guidelines)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

### Our Standards

- **Be Respectful**: Treat everyone with respect
- **Be Collaborative**: Work together towards common goals
- **Be Patient**: Remember that everyone is at different skill levels
- **Be Constructive**: Provide helpful feedback

## Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK
- Git
- A code editor (VS Code, Android Studio, or IntelliJ IDEA)
- Basic knowledge of Flutter and Dart

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/snake-app.git
   cd snake-app
   ```
3. Add the original repository as upstream:
   ```bash
   git remote add upstream https://github.com/chingalo-family/snake-app.git
   ```

## Development Setup

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

### Run Tests

```bash
flutter test
```

### Check Code Quality

```bash
flutter analyze
```

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- **Clear Title**: Descriptive summary of the issue
- **Description**: Detailed explanation of the problem
- **Steps to Reproduce**: Step-by-step instructions
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Screenshots**: If applicable
- **Environment**: Device, OS version, app version

**Bug Report Template:**
```markdown
### Description
[Clear description of the bug]

### Steps to Reproduce
1. Go to '...'
2. Tap on '...'
3. Swipe '...'
4. See error

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens]

### Screenshots
[If applicable]

### Environment
- Device: [e.g., iPhone 12, Samsung Galaxy S21]
- OS: [e.g., iOS 15.0, Android 12]
- App Version: [e.g., 1.0.1]
```

### Suggesting Features

Feature suggestions are welcome! Please:

- **Check Existing Suggestions**: Avoid duplicates
- **Explain the Use Case**: Why is this feature needed?
- **Describe the Solution**: How should it work?
- **Consider Alternatives**: Are there other approaches?

**Feature Request Template:**
```markdown
### Feature Description
[Clear description of the feature]

### Use Case
[Why is this feature needed?]

### Proposed Solution
[How should it work?]

### Alternatives Considered
[Other approaches considered]

### Additional Context
[Any other information]
```

### Working on Issues

1. **Find an Issue**: Look for issues tagged with `good first issue` or `help wanted`
2. **Comment**: Express interest in working on it
3. **Get Assigned**: Wait for maintainer approval
4. **Create Branch**: Create a feature branch
5. **Develop**: Work on your changes
6. **Test**: Ensure all tests pass
7. **Submit PR**: Create a pull request

## Coding Standards

### Dart/Flutter Style Guide

Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo).

### Key Principles

#### 1. Naming Conventions

```dart
// Classes: PascalCase
class SnakeState { }

// Files: snake_case
// snake_state.dart

// Variables: camelCase
int comboCount = 0;

// Constants: camelCase
const int defaultGridSize = 20;

// Private: prefix with underscore
int _score = 0;
```

#### 2. Code Organization

```dart
// Order: 
// 1. Imports
// 2. Constants
// 3. Fields
// 4. Constructor
// 5. Lifecycle methods
// 6. Public methods
// 7. Private methods

class ExampleWidget extends StatefulWidget {
  // 1. Constants
  static const double defaultHeight = 100.0;
  
  // 2. Fields
  final String title;
  
  // 3. Constructor
  const ExampleWidget({required this.title});
  
  // 4. Create state
  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  // 1. Fields
  int _counter = 0;
  
  // 2. Lifecycle methods
  @override
  void initState() {
    super.initState();
  }
  
  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  // 4. Public methods
  void increment() {
    _incrementCounter();
  }
  
  // 5. Private methods
  void _incrementCounter() {
    setState(() => _counter++);
  }
}
```

#### 3. Documentation

```dart
/// Calculates the final score with all multipliers applied.
///
/// This function combines the base score from food with bonus points
/// from combos, then applies both combo and power-up multipliers.
///
/// Example:
/// ```dart
/// final score = calculateScore(
///   baseScore: 50,
///   comboCount: 10,
///   powerUpMultiplier: 2.0,
/// );
/// ```
int calculateScore({
  required int baseScore,
  required int comboCount,
  double powerUpMultiplier = 1.0,
}) {
  // Implementation
}
```

#### 4. Error Handling

```dart
// ❌ Bad: Silent failure
try {
  await riskyOperation();
} catch (e) {
  // Nothing
}

// ✅ Good: Log and handle
try {
  await riskyOperation();
} catch (e) {
  debugPrint('Operation failed: $e');
  // Show user feedback
  _showError('Something went wrong');
}
```

#### 5. Widget Structure

```dart
// ❌ Bad: Deep nesting
Widget build(BuildContext context) {
  return Container(
    child: Column(
      children: [
        Container(
          child: Row(
            children: [
              Container(
                child: Text('Deep'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ✅ Good: Extract widgets
Widget build(BuildContext context) {
  return Container(
    child: Column(
      children: [
        _buildHeader(),
        _buildContent(),
      ],
    ),
  );
}

Widget _buildHeader() => Container(/* ... */);
Widget _buildContent() => Row(/* ... */);
```

### Formatting

Use `flutter format`:

```bash
flutter format lib/
```

### Linting

Ensure no lint warnings:

```bash
flutter analyze
```

## Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Examples

```bash
feat(game): add shield power-up

- Add shield model and constants
- Implement shield protection logic
- Add visual indicator for active shield

Closes #123
```

```bash
fix(combo): reset combo timer on food collection

The combo timer was not resetting properly when collecting food,
causing premature combo resets.

Fixes #456
```

### Scope Guidelines

- **game**: Game logic and mechanics
- **ui**: User interface components
- **state**: State management
- **models**: Data models
- **services**: Business logic services
- **docs**: Documentation

## Pull Request Process

### Before Submitting

1. **Update from Upstream**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run Tests**
   ```bash
   flutter test
   ```

3. **Check Code Quality**
   ```bash
   flutter analyze
   flutter format lib/
   ```

4. **Update Documentation**
   - Update relevant markdown files
   - Add code comments
   - Update CHANGELOG.md if applicable

### Creating a Pull Request

1. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Open PR on GitHub**
   - Clear title describing the change
   - Reference related issues
   - Provide detailed description
   - Add screenshots for UI changes

3. **PR Template**
   ```markdown
   ## Description
   [Clear description of changes]

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   - [ ] Code refactoring

   ## Related Issues
   Closes #[issue number]

   ## Testing
   - [ ] Unit tests added/updated
   - [ ] Manual testing performed
   - [ ] All tests passing

   ## Screenshots
   [If applicable]

   ## Checklist
   - [ ] Code follows style guidelines
   - [ ] Self-review completed
   - [ ] Comments added for complex code
   - [ ] Documentation updated
   - [ ] No new warnings generated
   ```

### Review Process

- Maintainers will review your PR
- Address feedback promptly
- Make requested changes
- Re-request review after updates

### Merging

- PRs require at least one approval
- All tests must pass
- No merge conflicts
- Squash and merge for clean history

## Testing Guidelines

### Unit Tests

Test business logic in isolation:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:snake_app/core/models/combo.dart';

void main() {
  group('Combo', () {
    test('should calculate correct multiplier', () {
      final combo = Combo(count: 10, multiplier: 2.0);
      expect(combo.multiplier, 2.0);
    });

    test('should return correct tier name for count', () {
      final combo = Combo(count: 5, multiplier: 1.5);
      expect(combo.tierName, 'GREAT');
    });
  });
}
```

### Widget Tests

Test UI components:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:snake_app/core/components/combo_display.dart';

void main() {
  testWidgets('ComboDisplay shows when combo >= 3', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ComboDisplay(),
        ),
      ),
    );

    // Verify display logic
    expect(find.text('COMBO'), findsOneWidget);
  });
}
```

### Test Coverage

Aim for:
- **Unit Tests**: 80%+ coverage for business logic
- **Widget Tests**: Critical UI components
- **Integration Tests**: Main user flows

Run with coverage:
```bash
flutter test --coverage
```

## Questions?

Feel free to ask questions by:
- Opening an issue
- Starting a discussion
- Contacting maintainers

## Thank You!

Your contributions make Snake App better for everyone. We appreciate your time and effort! 🎉

---

Happy Coding! 🐍✨
