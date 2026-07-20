# Contributing

1. Issue で目的と受け入れ条件を合意します。
2. `main` から `<type>/<issue>-<description>` ブランチを作ります。運用と並行作業の詳細は [`docs/branch-workflow.md`](docs/branch-workflow.md) を参照してください。
3. 振る舞いを変更する場合は [`docs/spec-driven-development.md`](docs/spec-driven-development.md) に従って requirements、design、tasks を承認してから実装します。
4. `AGENTS.md` の安全規約に従い、小さなコミットで実装します。
5. `./scripts/check.sh` を実行します。
6. Pull Request テンプレートをすべて記入し、人によるレビューと CI を通します。

コミット見出しは Conventional Commits の `feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `chore:` を使用してください。脆弱性は公開 Issue にせず、GitHub の Private vulnerability reporting を利用してください。
