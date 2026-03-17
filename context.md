# Flutter engineer rules

## Architecture
- Clean arch: /features/{name}/{data,domain,presentation}
- Routing: go_router
- State: Riverpod — AsyncNotifier for async, StateNotifier for sync
- Never use setState in production screens

## Design
- All tokens via ThemeExtension (colors, spacing, radius, typography)
- No hardcoded colors, sizes, or magic numbers anywhere
- Reusable widgets → /shared/widgets/

## Code quality  
- Null-safe always
- const constructors wherever possible
- AnimationController + Curves — never AnimatedContainer alone
- Extract widgets >50 lines into their own file

## Output rules
- File output only
- No explanations unless I explicitly ask
- After writing files, run dart analyze and fix errors silently
