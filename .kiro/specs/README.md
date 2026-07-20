# Feature specifications

機能ごとの仕様書を `<issue-number>-<kebab-case-name>/` に保存します。`../../scripts/new-spec.sh <issue-number> <name>` で requirements / design / tasks の雛形を作成できます。

仕様書の承認順序は次のとおりです。

1. `requirements.md`: 利用者の意図と検証可能な受け入れ条件を人が承認する。
2. `design.md`: 要件へのトレーサビリティ、境界、リスク、ロールバックを人が承認する。
3. `tasks.md`: 承認済み設計を小さな実装単位へ分解し、要件番号を対応付ける。
4. 実装: tasks の順に変更し、完了状態をコード・テストと同じ PR で更新する。

AI は承認済みの前段階を勝手に変更して先へ進みません。要件変更が必要になった場合は実装を止め、requirements → design → tasks の順で差分をレビューします。
