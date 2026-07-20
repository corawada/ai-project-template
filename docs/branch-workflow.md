# AI 開発のブランチ運用

人が後から変更を追えることを最優先にした推奨モデルです。基本単位を **1 Issue = 1 作業ブランチ = 1 Pull Request** とし、AI との会話ではなく GitHub を判断記録の正本にします。

## 推奨する構成

```text
main                         常にリリース可能。人だけが PR をマージする
 ├─ feat/123-user-profile    Issue #123 の機能追加
 ├─ fix/184-login-timeout    Issue #184 の不具合修正
 ├─ docs/205-api-guide       Issue #205 の文書変更
 └─ chore/219-ci-timeout     Issue #219 の保守作業
```

- `main` は唯一の長期ブランチにし、直接 commit / push しません。
- 作業ブランチは最新の `main` から作り、1 つの Issue だけを扱います。
- 名前は `<type>/<issue-number>-<short-description>` に統一します。担当 AI 名はブランチ名へ入れず、PR の AI 利用欄へ記録します。ツールを交代しても目的が変わらないためです。
- `develop` や AI 専用の長期ブランチは原則作りません。差分の滞留と統合時の因果関係を減らすためです。
- マージ後は作業ブランチを自動削除します。履歴は Issue、PR、squash commit に残ります。

## 変更を始める手順

```bash
git switch main
git pull --ff-only
git switch -c feat/123-user-profile
```

1. Issue に目的、受け入れ条件、対象外、リスクを記載します。
2. 上の規則でブランチを作り、AI へ Issue URL とブランチ名を渡します。
3. AI は編集前に `git status --short --branch` を表示し、対象 Issue とブランチが一致するか確認します。
4. 最初の意味のある差分で Draft PR を作ります。設計変更やスコープ変更はチャットだけで決めず、Issue または PR コメントへ残します。

## コミットを監査ログとして使う

作業中もレビュー可能な単位でコミットし、各コミットを「何を、なぜ変えたか」のチェックポイントにします。

```text
test: reproduce timeout from expired session
fix: reject expired session before token refresh
docs: document session expiration behavior
```

- 1 コミットには 1 つの論理変更だけを含めます。実装と、その実装を証明するテストは同じコミットでも構いません。
- `update`, `AI changes`, `WIP` のように意図が分からないメッセージは避けます。
- AI が作成したコミットには本文で `Assisted-by: Codex` または `Assisted-by: Claude Code` の trailer を任意で付けられます。AI を実在人物として扱う偽のメールアドレスや `Co-authored-by` は使用しません。
- remote へ push したコミットは、AI が rebase、amend、force push で書き換えません。修正は追加コミットにし、レビュー履歴を保持します。
- シークレットや本番データを履歴へ入れないでください。誤って入れた場合は追加コミットで消すだけでなく、直ちに credential を失効します。

## AI を交代・並行利用する場合

### 同じ目的を引き継ぐ

Codex から Claude Code へ交代しても、同じ Issue と目的なら同じブランチを使えます。先に現在の差分、直近コミット、PR の未解決コメントを読み取らせ、人が引き継ぎ範囲を指定します。PR の AI 利用欄には両方を記録します。

### 独立した作業を並行する

同じ working tree を複数 AI に同時編集させません。Issue とブランチを分け、必要なら `git worktree` で物理的にも分離します。

```bash
git worktree add ../project-issue-123 -b feat/123-user-profile main
git worktree add ../project-issue-184 -b fix/184-login-timeout main
```

片方の変更をもう片方が必要とする場合は、暗黙に cherry-pick するのではなく、依存する PR を本文に記載します。可能なら先行 PR を先に小さくマージし、後続ブランチを最新の `main` へ追従させます。

## Pull Request とマージ

人が追跡するときはコミットだけでなく、次の GitHub の関連付けを利用します。

1. PR 本文の `Closes #123` で要求と実装を結びます。
2. AI ツール、依頼した範囲、人が確認・修正した範囲を記録します。
3. 検証コマンドと結果、破壊的変更、ロールバック方法を記録します。
4. レビュー指摘は行コメントで残し、修正コミット後に会話を解決します。
5. 必須 CI と人の承認後、人が **Squash and merge** します。
6. squash commit のタイトルは Conventional Commits、本文は PR 番号を含む状態にします。

Squash merge は `main` を Issue / PR ごとの読みやすい履歴にし、revert の単位も明確にします。一方、PR 内の個々のコミットとレビュー履歴は GitHub に残るため、途中の判断も追跡できます。

## ブランチ更新と競合

- 短命ブランチを基本とし、Draft PR を小さく保って競合を減らします。
- 必須 status check が最新 `main` との同期を要求したら、作業者が `main` を取り込み、競合部分を人がレビューします。
- AI に競合解消を任せる場合は、競合したファイルと採用した仕様を人が明示し、解消後に全テストを再実行します。
- 大規模な競合、生成物、migration の競合は自動判断させず、人が解決します。

## 例外を増やさない

| 状況 | 推奨する扱い |
| --- | --- |
| 緊急 hotfix | `fix/<issue>-<description>` から短い PR。`main` への直接 push はしない |
| 実験・調査 | `spike/<issue>-<description>`。成果を Issue に残し、製品コードへ直接マージしない |
| 大きな機能 | feature branch を長期化せず、feature flag の背後で複数の独立 PR に分割 |
| PR が別目的へ拡大 | 新しい Issue とブランチへ分離 |
| AI の誤変更 | force push で隠さず、修正コミットまたは PR の revert で履歴を残す |

## マージ前チェック

- [ ] ブランチ名、Issue、PR の目的が一致している
- [ ] PR に含まれる全コミットを人が説明できる
- [ ] AI の利用範囲と人による確認範囲が記録されている
- [ ] 未解決のレビュー会話がなく、必須 CI が成功している
- [ ] 破壊的変更とロールバック方法が記録されている
- [ ] マージを実行するのは人である
