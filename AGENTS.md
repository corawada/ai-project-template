# AI agent instructions

この規約はリポジトリ全体に適用されます。Codex、Claude Code、その他の自動化ツールは必ず従ってください。

## 作業開始前

1. `git status --short --branch` で現在のブランチと既存変更を確認する。
2. `main`、`master`、`develop`、`release/*` 上ではファイルを変更しない。`feat/*`、`fix/*`、`docs/*`、`chore/*` 等の作業ブランチへ移る。
3. 関連 Issue、受け入れ条件、非目標を確認する。曖昧な破壊的変更は実施せず、人に確認する。
4. 既存の未コミット変更を上書き、削除、stash しない。

## 仕様書駆動開発

- 新機能や振る舞いの変更は、実装前に `.kiro/specs/<issue>-<name>/` の `requirements.md`、`design.md`、`tasks.md` を順に作成する。
- 人が requirements を承認するまで design へ進まず、design を承認するまで tasks と実装へ進まない。
- 実装は承認済み tasks と要件番号へ対応させる。仕様変更時は実装を止め、requirements → design → tasks の順に更新・再承認する。
- 長期的なプロダクト・技術・構造の前提は `.kiro/steering/` を正本とし、機能固有の判断と混在させない。

## 実装の原則

- 必要最小限の差分にし、無関係なリファクタリングや依存関係更新を混ぜない。
- 既存 API、データ、設定の互換性を壊す変更、migration、認証・権限変更は事前に明示的な承認を得る。
- シークレット、トークン、個人情報、本番データを読み取り・出力・コミットしない。
- 危険なコマンド（`git reset --hard`、`git clean -fd`、force push、履歴書き換え、大量削除）を実行しない。
- import を `try/catch` で囲まない。
- 生成物ではなく、可能なら生成元を変更する。
- 振る舞いの変更にはテストと文書を同じ PR で追加・更新する。

## Git / GitHub

- 保護ブランチへ直接 push、merge しない。変更は Pull Request 経由にする。
- ブランチは原則 `<type>/<issue-number>-<short-description>` とし、1 Issue = 1 ブランチ = 1 PR にする。詳細は `docs/branch-workflow.md` に従う。
- コミットは単一の意味を持たせ、`feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `chore:` から始める。
- remote へ push 済みのコミットを rebase、amend、force push で書き換えない。AI の修正は追跡可能な追加コミットにする。
- PR には Issue、変更理由、AI の利用範囲、リスク、ロールバック、実行した検証を記載する。
- AI が生成した内容も人が理解・レビューできる状態にする。検証していないことを「成功」と報告しない。
- CI やレビューを迂回、無効化しない。

## 完了条件

1. `./scripts/check.sh` を実行する。
2. `git diff --check` と `git status --short` で意図したファイルだけが変更されたことを確認する。
3. 変更内容、検証コマンドと結果、残るリスクを報告する。
