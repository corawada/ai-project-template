# AWS / Kiro 型の仕様書駆動開発

このテンプレートでは、AWS が提供する Kiro の Spec-driven development の考え方に合わせ、曖昧な依頼から直接コードを生成せず、**Requirements → Design → Tasks → Implementation** の順に合意を積み上げます。各段階を Git の差分と GitHub のレビューに残すことで、人が AI の判断を後から追跡できます。

## ファイルの役割

```text
.kiro/
├── steering/
│   ├── product.md    プロダクトの目的・利用者・原則
│   ├── tech.md       技術スタック・制約・標準コマンド
│   └── structure.md  ディレクトリ責務・命名規則
├── settings/templates/specs/
│   ├── requirements.md
│   ├── design.md
│   └── tasks.md
└── specs/
    └── 123-feature-name/
        ├── requirements.md
        ├── design.md
        └── tasks.md
```

`steering` は複数機能にまたがる安定した前提です。頻繁に変わる機能要件は入れません。`specs` は Issue ごとの成果物であり、コードと同様に PR でレビューします。

## 0. Steering を整備する

初回利用時に `.kiro/steering/` の TODO を人が埋めます。AI が勝手に技術選定やプロダクト目的を確定しないよう、少なくとも対象利用者、技術スタック、標準テストコマンド、セキュリティ制約、ディレクトリ責務を合意してください。前提を変更すると既存 spec に影響する場合は、独立した PR にして影響対象を記載します。

## 1. Requirements

```bash
./scripts/new-spec.sh 123 feature-name
```

`requirements.md` には実装方法ではなく、ユーザーストーリーと検証可能な受け入れ条件を書きます。受け入れ条件には EARS に基づく定型を使います。

- `WHEN <event>, THE SYSTEM SHALL <response>`: イベント駆動
- `IF <condition>, THEN THE SYSTEM SHALL <response>`: 望ましくない状態
- `WHILE <state>, THE SYSTEM SHALL <behavior>`: 状態駆動
- `WHERE <option>, THE SYSTEM SHALL <behavior>`: オプション機能
- `THE SYSTEM SHALL <behavior>`: 常時成立

各条件へ `1.1`, `1.2` のような安定した番号を付けます。「高速」「適切」のような主観語は、応答時間や認可結果など測定可能な表現へ置き換えます。人が要件、対象外、未解決事項を承認するまで設計へ進みません。

## 2. Design

`design.md` で要件を実現する構成、interface、data model、失敗時の振る舞い、security、observability、migration、rollback、test strategy を決定します。Requirement traceability 表で、すべての要件番号を設計要素と検証方法へ対応させます。

AI に複数案を出させることはできますが、採用理由とトレードオフは人が確認します。認証、データ削除、公開 API、migration、課金、外部サービス追加は明示的な承認なしに確定しません。

## 3. Tasks

`tasks.md` は設計を小さな実装ステップへ変換します。各タスクは次を満たします。

- コード、テスト、文書として完了を検証できる
- `_Requirements: 1.1, 2.1_` のように要件番号を参照する
- 1つのレビュー可能な変更単位である
- 「全体を実装する」のような巨大タスクではない
- deployment、migration、monitoring、rollback も必要に応じて含む

## 4. Implementation

AI へは「次の未完了タスク 1 件だけ」を依頼します。実装後、人が差分とテストを確認してからチェックボックスを更新します。チェックだけを先行させたり、未実施の検証を完了扱いにしたりしません。

```text
.kiro/specs/123-feature-name/tasks.md の 2.1 だけを実装してください。
対応要件 1.1 と承認済み design を変更せず、テストを追加してください。
仕様と矛盾した場合は実装を止め、矛盾点を報告してください。
```

## 変更管理と GitHub レビュー

推奨は 1 Issue = 1 spec = 1 branch = 1 PR です。大きな機能では仕様策定 PR と実装 PR を分けても構いません。その場合、実装 PR から承認済み spec PR と Issue をリンクします。

仕様変更はコードへ合わせて事後修正せず、次の順で扱います。

1. Issue / PR に変更理由と影響を記録する。
2. requirements の差分をレビュー・承認する。
3. design の影響範囲、互換性、rollback を更新・承認する。
4. tasks を再構成してから実装を再開する。

軽微な typo やコードを変更しない文書修正では spec を省略できます。PR の「仕様書が不要な変更」を選択し、理由を記載してください。

## 完了条件

- `./scripts/check-specs.sh` が成功する
- requirements の全条件に設計、タスク、テストの対応先がある
- tasks の完了状態が実際のコード・検証結果と一致する
- 未解決事項、破壊的変更、migration、rollback が PR に記録されている
- 人が最終差分を説明でき、マージを実行する
