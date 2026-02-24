# Design: Match-Pair Game (对对碰游戏)

## 技术栈
- **HTML5/CSS3** - 布局与 3D 翻转动画
- **原生 JavaScript** - 核心逻辑控制

## 核心逻辑
1. **洗牌算法**: 使用 Fisher-Yates 算法随机打乱牌组。
2. **状态管理**: 
   - `flippedCards`: 存储当前翻开的牌。
   - `matchedPairs`: 记录已配对的数量。
3. **匹配逻辑**: 
   - 当翻开两张牌时，对比其内容。
   - 若匹配：保持显示，`matchedPairs++`。
   - 若不匹配：延迟 1 秒后自动翻回。

## UI/UX
- **卡片设计**: 正面显示符号/数字，背面显示 Javis Logo 样式。
- **布局**: 4x4 居中网格。
- **动画**: 使用 CSS `transform: rotateY(180deg)` 实现平滑翻转。

## 目录结构
```
myopencode/
└── match-pair.html (单文件)
```
