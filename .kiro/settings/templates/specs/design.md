# Design document

## Overview

<!-- requirements.md を満たす設計の要約。設計判断とトレードオフを記載する。 -->

## Requirement traceability

| Requirement | Design element | Verification |
| --- | --- | --- |
| 1.1 | <!-- component/API --> | <!-- test/metric --> |

## Architecture

```mermaid
flowchart LR
  A[Client] --> B[Component]
```

## Components and interfaces

### <!-- Component name -->

- **Responsibility:**
- **Inputs / outputs:**
- **Failure behavior:**
- **Authorization boundary:**

## Data models

<!-- schema、validation、ownership、retention を記載する。該当しない場合は「なし」と理由を書く。 -->

## Correctness properties

<!-- 複数入力に対して常に成立すべき性質。property-based test の候補にする。 -->

1. **Property 1:** For any <!-- input domain -->, <!-- invariant linked to requirement -->.

## Error handling and observability

- エラー分類と利用者への応答:
- log / metric / trace（秘密・個人情報を含めない）:
- retry / timeout / idempotency:

## Security and privacy

- Threats and trust boundaries:
- Authentication / authorization:
- Secret and personal-data handling:

## Migration, compatibility, and rollback

- Compatibility impact:
- Migration / feature flag:
- Rollback procedure:

## Testing strategy

- Unit:
- Integration:
- End-to-end:
- Property / fuzz:

## Design decisions

| Decision | Alternatives | Reason | Consequences |
| --- | --- | --- | --- |
| <!-- selected approach --> | <!-- rejected options --> | <!-- why --> | <!-- tradeoff --> |
