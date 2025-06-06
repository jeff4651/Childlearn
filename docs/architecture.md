# iOS App 架構概述

本專案目標是開發一款給小朋友使用的英文學習 App，主要分成三大功能模組：

1. **學習英文（Learning）**：提供單字、句型與發音等教材，搭配圖片與音效，讓小朋友能夠循序漸進學習。
2. **互動（Interaction）**：透過小遊戲、問答或語音互動等方式，加強學習興趣並提升記憶。
3. **回顧（Review）**：整理學過的內容，提供測驗與成就系統，協助小朋友複習與追蹤學習進度。

## 架構建議

- **SwiftUI 與 MVVM**：介面以 SwiftUI 建構，使用 MVVM 模式管理狀態與資料流。
- **模組化資料夾**：
  - `Learning/`：學習相關的畫面、模型與資源
  - `Interaction/`：互動遊戲、問答等邏輯
  - `Review/`：複習與測驗功能
- **資料管理**：
  - 使用 `CoreData` 或 `Realm` 儲存離線進度
  - 依需求串接雲端 API 獲取更新內容
- **UI/UX 考量**：
  - 大圖示與簡單操作流程，適合兒童使用
  - 音效與動畫增加互動性

## 專案初始結構範例

```
Childlearn/
├── docs/
│   └── architecture.md
├── App/
│   ├── Learning/
│   │   ├── Word.swift
│   │   └── WordLearningView.swift
│   ├── Interaction/
│   └── Review/
└── README.md
```

目前 `Learning` 資料夾中提供一個簡單的 `Word` 模型與 `WordLearningView` 範例畫面，
示範如何呈現單字、圖片、發音與例句。此檔案將隨著專案進度持續更新。
