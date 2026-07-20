# GitHub の保護設定

リポジトリ内の指示や Git hook は事故を減らしますが、`--no-verify` で回避できます。最終的な強制境界には GitHub Rulesets を使用してください。

## 自動設定

管理権限のある GitHub CLI で次を実行します。

```bash
./scripts/bootstrap-github.sh
```

このスクリプトはラベル、Actions の read-only 既定権限、`main` ruleset を作成します。同名 ruleset が存在する場合は上書きしません。

## Ruleset の確認項目

**Settings → Rules → Rulesets** で `main` に次が適用されていることを確認します。

- Active（Evaluate ではない）
- branch deletion と non-fast-forward push の禁止
- Pull Request 必須
- 承認 1 件以上、最後の push は別の人が承認
- 古い承認を dismiss、全 conversation を resolve
- `repository checks` status check 必須、最新 `main` との同期必須
- merge method は squash のみ
- bypass actor なし（管理者・AI token も迂回不可）

個人リポジトリで承認者が一人しかいない場合、必須承認によって自己マージできません。安全性を優先する既定値です。必要なら信頼できる共同開発者を追加してください。承認数を 0 に下げる場合も PR と CI は維持し、差分を自分でレビューします。

## 追加の推奨設定

- **General → Pull Requests**: squash merge と auto-delete head branches を有効化
- **Actions → General**: fork PR の workflow approval、read repository contents permission
- **Code security**: Dependabot alerts、secret scanning、push protection、private vulnerability reporting
- **Environments**: `production` に required reviewer を設定し、secret を environment に限定
- **Tags**: `v*` に deletion / update 禁止の tag ruleset を追加

## Actions が失敗または skip される場合

`quality / repository checks` は公開・非公開にかかわらず PR で実行されます。CodeQL は解析言語を指定する必要がありますが、このテンプレートは利用言語を事前に決められません。そのため CodeQL workflow は PR で自動実行せず、**Actions → codeql → Run workflow** から対象言語（例: `javascript-typescript`、`python`）を入力した場合だけ実行します。アプリケーションコードを追加して手動実行に成功した後、プロジェクトに合わせて `pull_request`、`push`、`schedule` trigger を追加してください。

CodeQL code scanning と dependency review は、公開リポジトリでは利用できますが、非公開リポジトリでは GitHub Advanced Security が必要です。Dependency review は、利用できない機能によって初回 PR が失敗しないよう、非公開リポジトリでは既定で skip します。非公開リポジトリで GitHub Advanced Security を有効にした場合は、**Settings → Secrets and variables → Actions → Variables** で opt-in 用 repository variable を追加します。

| 機能 | Variable | 値 |
| --- | --- | --- |
| Dependency review | `ENABLE_DEPENDENCY_REVIEW` | `true` |

job が skip された状態は失敗ではありません。Dependency review を branch ruleset の必須 status check に設定する場合は、先に対象機能と variable を有効にし、PR で一度成功させてから必須化してください。手動実行のままの CodeQL は PR の必須 check に設定できません。常に必須にする check は `quality / repository checks` です。

失敗を調査するときは、PR の **Checks** で失敗した job と step を開き、ログ先頭のエラーを確認します。権限または機能の利用可否が原因なら保護ルールを弱めるのではなく、上記の条件を確認してください。コード検査が原因ならローカルで `./scripts/check.sh` を再現します。

## 権限設計

AI には可能なら GitHub の read 権限だけを与え、PR 作成が必要な場合も contents write の短命・最小権限 token に限定します。Administration、Secrets、Actions workflow、Rulesets の変更権限は与えません。個人アクセストークンをリポジトリやプロンプトへ保存せず、GitHub App または細粒度 token を使います。

## 緊急変更

通常ルールを解除して直接 push しません。hotfix ブランチから小さな PR を作り、必須 CI とレビューを通します。真にサービス復旧を妨げる場合の bypass は、対象者、期限、理由、事後レビューを別途記録し、作業後ただちに無効化します。
