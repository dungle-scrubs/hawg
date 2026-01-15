# Contributing

## Development Setup

```bash
git clone https://github.com/dungle-scrubs/hawg.git
cd hawg
swift build
swift test
```

## Making Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`swift test`)
5. Run linter (`swiftlint lint`)
6. Commit your changes
7. Push to the branch
8. Open a Pull Request

## Code Style

- Follow SwiftLint rules (see `.swiftlint.yml`)
- Keep functions small and focused
- Add tests for new functionality

## Testing

```bash
swift test
```

All new features should include unit tests in `Tests/HawgCoreTests/`.
