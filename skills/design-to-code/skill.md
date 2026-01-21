---
name: design-to-code
description: Converts Figma designs into code components. Auto-detects project's framework and component libraries. Use when implementing designs from Figma or translating mockups to code.
allowed-tools: Read, Grep, Glob, Edit, Write
---

# Design-to-Code Translator (Generic)

## Auto-Detection Strategy

This skill adapts to ANY frontend project by:
1. Detecting the framework (React, Vue, Svelte, etc.)
2. Finding existing component libraries in package.json
3. Matching project's styling approach
4. Following existing patterns in the codebase

---

## Step 1: Detect Project Setup

### Read package.json
Extract:
```json
{
  "framework": "react|vue|svelte|angular",
  "component_libraries": ["<from dependencies>"],
  "styling": "tailwind|styled-components|css-modules|scss|emotion"
}
```

### Component Library Priority (Auto-Detected)

**ALWAYS use this order:**

1. **Project's existing component library** (Highest Priority)
   - Check package.json for UI libraries
   - Common ones: MUI, Chakra, Ant Design, Primer, Radix, shadcn/ui
   - Use whatever the project already has

2. **Project's custom components** (Second Priority)
   - Search for existing components in the codebase
   - Check common paths: `src/components/`, `components/`, `src/ui/`

3. **Create new component** (Last Resort)
   - Only if nothing suitable exists
   - Follow project's existing component patterns

### Detect Styling Approach

Check for:
- `tailwind.config.js` → Tailwind CSS
- `styled-components` in deps → Styled Components
- `.module.css` files → CSS Modules
- `.scss` files → SCSS
- `@emotion` in deps → Emotion
- `theme.js` or `theme.ts` → Theme system

---

## Step 2: Extract Design Specifications

### From Figma Design, Extract:

**Design Tokens:**
- Colors: HEX codes, opacity values
- Spacing: Padding, margin (usually 4px/8px grid)
- Typography: Font family, size, weight, line-height
- Borders: Width, radius, color
- Shadows: Box-shadow values

**Component Structure:**
- Layout type (flex, grid)
- Component hierarchy
- Responsive breakpoints
- Interactive states (hover, active, disabled)

---

## Step 3: Map to Project's Stack

### Framework-Specific Mapping

**React:**
```jsx
// Figma Frame → div or semantic HTML
// Auto Layout → CSS Flexbox/Grid
// Variants → Component props
// Instances → Reusable component
```

**Vue:**
```vue
<template>
  <!-- Figma structure → Vue template -->
</template>
<script setup>
// Props from variants
</script>
<style scoped>
/* Styles from Figma */
</style>
```

**Svelte:**
```svelte
<!-- Figma structure → Svelte markup -->
<script>
  // Props from variants
</script>
<style>
  /* Styles from Figma */
</style>
```

### Styling Approach Mapping

**If Tailwind:**
```jsx
<div className="flex gap-4 p-6 bg-blue-500 rounded-lg">
```

**If CSS Modules:**
```jsx
import styles from './Component.module.css';
<div className={styles.container}>
```

**If Styled Components:**
```jsx
const Container = styled.div`
  display: flex;
  gap: 1rem;
`;
```

**If SCSS:**
```jsx
import './Component.scss';
<div className="component-container">
```

---

## Step 4: Component Library Usage

### Auto-Detect Available Components

Search package.json for these libraries and use their components:

**Material UI (@mui/material):**
```jsx
import { Button, TextField, Card } from '@mui/material';
```

**Chakra UI (@chakra-ui/react):**
```jsx
import { Button, Input, Box } from '@chakra-ui/react';
```

**Ant Design (antd):**
```jsx
import { Button, Input, Card } from 'antd';
```

**Primer React (@primer/react):**
```jsx
import { Button, TextInput, Box } from '@primer/react';
```

**Radix UI (@radix-ui/*):**
```jsx
import * as Dialog from '@radix-ui/react-dialog';
```

**shadcn/ui:**
```jsx
import { Button } from '@/components/ui/button';
```

### Finding Existing Custom Components

```bash
# Search for components in common locations
grep -r "export.*function\|export.*const" src/components/
grep -r "export default" src/Components/
```

---

## Step 5: Implementation Workflow

### 5.1 Analyze Design Structure
- Identify top-level container
- List all child components
- Note spacing relationships
- Identify variants/states

### 5.2 Check for Existing Components
```
Search for similar components:
1. In project's component library
2. In src/components/ or equivalent
3. In project's UI kit
```

### 5.3 Extract CSS Properties from Figma

From Figma's "Inspect" panel:
- Layout (display, flex-direction, gap)
- Sizing (width, height, min/max)
- Spacing (padding, margin)
- Colors (background, text, borders)
- Typography (font, size, weight)

### 5.4 Implement Component

**Template (React + detected styling):**

```jsx
import React from 'react';
// Import from detected component library
// Import styles based on detected approach

const ComponentName = ({ prop1, prop2 }) => {
  return (
    <div className={/* based on styling approach */}>
      {/* Implementation matching project patterns */}
    </div>
  );
};

export default ComponentName;
```

### 5.5 Visual Verification
- Compare with design pixel-by-pixel
- Test all interactive states
- Verify responsive behavior

---

## Common Patterns

### Layout Grid (8px base - universal)
```
4px  = 0.25rem  (Tailwind: p-1)
8px  = 0.5rem   (Tailwind: p-2)
12px = 0.75rem  (Tailwind: p-3)
16px = 1rem    (Tailwind: p-4)
24px = 1.5rem  (Tailwind: p-6)
32px = 2rem    (Tailwind: p-8)
```

### Figma → CSS Mapping

**Auto Layout → Flexbox:**
```
Figma: Auto Layout (Horizontal, 16px gap)
CSS:   display: flex; gap: 1rem;
Tailwind: flex gap-4
```

**Constraints → CSS:**
```
Figma: Left + Right → width: 100%
Figma: Center → margin: 0 auto
```

**Effects → CSS:**
```
Figma: Drop Shadow (0, 4, 8, rgba(0,0,0,0.1))
CSS:   box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1)
Tailwind: shadow-md
```

---

## Responsive Implementation

**Mobile-first approach:**
```css
/* Mobile: 320px - 767px */
.component { width: 100%; }

/* Tablet: 768px - 1023px */
@media (min-width: 768px) { }

/* Desktop: 1024px+ */
@media (min-width: 1024px) { }
```

**Tailwind responsive:**
```jsx
<div className="w-full md:w-1/2 lg:w-1/3">
```

---

## Tips

- Always check package.json first for available libraries
- Search codebase for similar components before creating new
- Match the project's existing code style
- Use theme variables when available
- Test responsive behavior at common breakpoints
- Document any deviations from design with reasoning
