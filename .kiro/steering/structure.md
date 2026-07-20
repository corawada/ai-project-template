# Project structure

<!-- 実際のディレクトリ構成と責務に更新してください。 -->

## Repository map

```text
.github/     GitHub automation and templates
.kiro/       steering and feature specifications
docs/        project documentation
scripts/     local and CI automation
```

## Placement rules

- 新しいコードは既存の責務境界に従い、設計書で配置理由を説明する。
- テストは対象コードから発見しやすい既存の規則に合わせる。
- 生成物ではなく生成元を変更する。
- 公開 API、永続化形式、環境変数の変更は design の migration / compatibility 欄へ記録する。

## Naming conventions

- Branch: `<type>/<issue-number>-<short-description>`
- Spec: `.kiro/specs/<issue-number>-<kebab-case-name>/`
- Commit: Conventional Commits
