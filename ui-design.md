# UI Design System

**Framework:** React + TypeScript + Tailwind CSS v4
**Design Philosophy:** Clean, compact, professional, data-dense

This document serves as a complete reference for AI coding assistants to replicate the exact UI design of GTM Machine v3 sin other applications.

---

## 1. Color Palette

### Primary Brand Color
```css
--color-primary-50: #eff6ff   /* Very light blue - hover states, backgrounds */
--color-primary-100: #dbeafe  /* Light blue */
--color-primary-200: #bfdbfe  /* */
--color-primary-300: #93c5fd  /* */
--color-primary-400: #60a5fa  /* */
--color-primary-500: #0088ff  /* Main brand color - buttons, links, active states */
--color-primary-600: #0066cc  /* Hover state for primary buttons */
--color-primary-700: #0055aa  /* */
--color-primary-800: #004488  /* */
--color-primary-900: #003366  /* Darkest blue */
```

### Accent Color
- **Orange**: `#f97316` (orange-500)
  - Used for logo background
  - Used sparingly for emphasis

### Neutral Gray Scale (Tailwind defaults)
- **gray-50**: `#f9fafb` - Page backgrounds
- **gray-100**: `#f3f4f6` - Secondary button backgrounds, card backgrounds
- **gray-200**: `#e5e7eb` - Borders, dividers
- **gray-300**: `#d1d5db` - Input borders (default state)
- **gray-400**: `#9ca3af` - Icons, placeholders
- **gray-500**: `#6b7280` - Secondary text
- **gray-600**: `#4b5563` - */
- **gray-700**: `#374151` - Body text, navigation text
- **gray-900**: `#111827` - Headings, primary text

### Semantic Colors
- **Success**: Not defined (use Tailwind green if needed)
- **Danger/Error**: `red-500` (#ef4444), `red-600` (hover)
- **Warning**: Not defined (use Tailwind yellow if needed)

---

## 2. Typography

### Font Family
- **Default**: System font stack (Tailwind default)
- **Code/Monospace**: Not used in this application

### Font Sizes (Tailwind scale)
Application uses **compact, data-dense** sizing:

- **text-xs**: `12px` (0.75rem)
  - Labels, helper text, table headers, input fields, secondary information
- **text-sm**: `14px` (0.875rem)
  - **Primary body text**, navigation items, buttons, most UI elements
- **text-base**: `16px` (1rem)
  - Page headings (rarely used, application favors compact design)

### Font Weights
- **font-normal**: `400` - Default body text
- **font-medium**: `500` - Labels, active nav items, table headers, buttons
- **font-semibold**: `600` - Headings, emphasis
- **font-bold**: `700` - Logo, strong emphasis (rare)

### Text Colors
- **text-gray-900**: Primary text (headings, important information)
- **text-gray-700**: Body text, navigation items
- **text-gray-500**: Secondary text, muted information, table headers
- **text-primary-600**: Active navigation items, links
- **text-red-500**: Error messages, required field markers
- **text-white**: Text on colored backgrounds (buttons, badges)

---

## 3. Spacing System

Application uses **tight, compact spacing** for data density.

### Gap Spacing (between elements)
- **gap-0.5**: `2px` - Navigation items vertical spacing
- **gap-1**: `4px` - Very tight element spacing
- **gap-2**: `8px` - Default spacing between related elements
- **gap-2.5**: `10px` - Navigation icon-text spacing
- **gap-3**: `12px` - Section spacing

### Padding
- **px-2**: `8px` horizontal - Small elements
- **px-2.5**: `10px` horizontal - Button small, navigation items
- **px-3**: `12px` horizontal - Button medium, input fields
- **px-4**: `16px` horizontal - Button large, table cells, cards
- **py-1**: `4px` vertical - Very compact
- **py-1.5**: `6px` vertical - **Standard vertical padding** (buttons, inputs, nav items)
- **py-2**: `8px` vertical - Table headers, larger buttons
- **py-3**: `12px` vertical - Card padding, section padding

### Margin
- **mb-1**: `4px` - Label-to-input spacing
- **ml-0.5**: `2px` - Required field marker spacing
- **space-y-0.5**: `2px` vertical spacing between navigation items

---

## 4. Border Radius

```css
--radius-lg: 8px   /* Default for buttons, inputs, cards, modals */
--radius-xl: 12px  /* Larger radius for special cases */
```

### Usage
- **rounded-lg**: `8px` - **Standard radius** for all components (buttons, inputs, cards, nav items)
- **rounded-full**: `9999px` - User avatars, icon containers
- **rounded-xl**: `12px` - Large cards, modals (rare)

---

## 5. Shadows

```css
--shadow-soft: 0 1px 3px rgba(0, 0, 0, 0.05)     /* Subtle elevation */
--shadow-medium: 0 2px 8px rgba(0, 0, 0, 0.08)   /* Cards, dropdowns */
--shadow-large: 0 4px 16px rgba(0, 0, 0, 0.12)   /* Modals, overlays */
```

### Usage
Application uses **minimal shadows** for a flat, clean look:
- Most cards and tables use `border border-gray-100` instead of shadows
- Modals may use medium/large shadows for depth

---

## 6. Layout

### Page Structure
```tsx
<div className="min-h-screen bg-gray-50">
  <aside className="fixed left-0 top-0 h-screen w-56 bg-white border-r border-gray-200">
    {/* Sidebar Navigation */}
  </aside>
  <main className="ml-56 min-h-screen">
    {/* Page Content */}
  </main>
</div>
```

### Sidebar Navigation
- **Width**: `w-56` (224px) - Fixed width
- **Background**: `bg-white`
- **Border**: `border-r border-gray-200`
- **Position**: `fixed left-0 top-0 h-screen`

#### Logo Area
- **Height**: `h-12` (48px)
- **Padding**: `px-4`
- **Border**: `border-b border-gray-200`

#### Logo Icon
- **Size**: `w-7 h-7` (28px × 28px)
- **Background**: `bg-orange-500`
- **Radius**: `rounded-lg`
- **Text**: `text-white font-bold text-xs`

#### Navigation Items
```tsx
<NavLink className={
  isActive
    ? 'bg-primary-50 text-primary-600 font-medium'
    : 'text-gray-700 hover:bg-gray-100'
} className="flex items-center gap-2.5 px-2.5 py-1.5 rounded-lg text-sm">
  <Icon size={18} />
  <span>{name}</span>
</NavLink>
```

- **Padding**: `px-2.5 py-1.5` (10px × 6px)
- **Icon Size**: `18px`
- **Text Size**: `text-sm` (14px)
- **Gap**: `gap-2.5` (10px between icon and text)
- **Active State**: `bg-primary-50 text-primary-600 font-medium`
- **Hover State**: `hover:bg-gray-100`

#### User Profile Section
- **Position**: Bottom of sidebar
- **Padding**: `p-3` (12px)
- **Border**: `border-t border-gray-200`
- **Avatar**: `w-7 h-7 bg-gray-200 rounded-full`
- **Text**: `text-xs` for name and email

### Main Content Area
- **Margin**: `ml-56` (224px to clear sidebar)
- **Background**: Inherits `bg-gray-50` from parent

---

## 7. Buttons

### Button Component API
```tsx
<Button
  variant="primary" | "secondary" | "danger" | "ghost"
  size="sm" | "md" | "lg"
  isLoading={boolean}
/>
```

### Variants
```tsx
primary: 'bg-primary-500 text-white hover:bg-primary-600'
secondary: 'bg-gray-100 text-gray-900 hover:bg-gray-200'
danger: 'bg-red-500 text-white hover:bg-red-600'
ghost: 'text-gray-700 hover:bg-gray-100'
```

### Sizes
```tsx
sm: 'px-2.5 py-1 text-xs'      // Small: 10px×4px, 12px text
md: 'px-3 py-1.5 text-sm'      // Medium (default): 12px×6px, 14px text
lg: 'px-4 py-2 text-base'      // Large: 16px×8px, 16px text
```

### Base Styles
```tsx
className="inline-flex items-center justify-center font-medium rounded-lg transition-colors
focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-1
disabled:opacity-50 disabled:cursor-not-allowed"
```

### Loading State
- Shows spinning icon (`h-4 w-4`) with `-ml-1 mr-2` spacing
- Button is disabled when `isLoading` is true

---

## 8. Form Inputs

### Input Component
```tsx
<Input
  label="Field Label"
  error="Error message"
  icon={<IconComponent />}
  required
/>
```

### Label
- **Class**: `text-xs font-medium text-gray-700 mb-1`
- **Size**: `12px`
- **Spacing**: `4px` below label
- **Required Indicator**: `<span className="text-red-500 ml-0.5">*</span>`

### Input Field
```tsx
className="w-full px-3 py-1.5 text-xs border rounded-lg transition-colors
focus:ring-2 focus:ring-primary-500 focus:border-primary-500 outline-none
disabled:bg-gray-50 disabled:text-gray-500 disabled:cursor-not-allowed"
```

- **Padding**: `px-3 py-1.5` (12px × 6px)
- **Text Size**: `text-xs` (12px)
- **Border**: `border-gray-300` (default), `border-red-500` (error)
- **Radius**: `rounded-lg` (8px)
- **Focus State**:
  - `ring-2 ring-primary-500`
  - `border-primary-500`
- **With Icon**: Add `pl-8` class, icon positioned `left-2.5 top-2`

### Error Message
- **Class**: `mt-1 text-xs text-red-500`
- **Size**: `12px`
- **Spacing**: `4px` above error text

### Select, Textarea
Follow same sizing and styling as Input component.

---

## 9. Tables

### Table Container
```tsx
<div className="bg-white rounded-lg border border-gray-100 overflow-hidden">
  <div className="overflow-x-auto">
    <table className="w-full">
      {/* ... */}
    </table>
  </div>
</div>
```

### Table Header
```tsx
<thead className="bg-gray-50 border-b border-gray-200">
  <tr>
    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
      Header
    </th>
  </tr>
</thead>
```

- **Background**: `bg-gray-50`
- **Border**: `border-b border-gray-200`
- **Padding**: `px-4 py-2` (16px × 8px)
- **Text**: `text-xs font-medium text-gray-500 uppercase tracking-wider`

### Table Body
```tsx
<tbody className="divide-y divide-gray-200">
  <tr className="hover:bg-gray-50 cursor-pointer transition-colors">
    <td className="px-4 py-2.5 text-xs text-gray-900">
      Cell content
    </td>
  </tr>
</tbody>
```

- **Row Dividers**: `divide-y divide-gray-200`
- **Hover**: `hover:bg-gray-50` (if clickable)
- **Cell Padding**: `px-4 py-2.5` (16px × 10px)
- **Text**: `text-xs text-gray-900`

### Sortable Headers
- Add `cursor-pointer select-none hover:bg-gray-100` to `<th>`
- Show `<ChevronUp size={14} />` or `<ChevronDown size={14} />` icon

### Loading State
```tsx
<div className="bg-white rounded-lg border border-gray-100 overflow-hidden">
  <div className="p-8 flex items-center justify-center">
    <div className="animate-spin rounded-full h-8 w-8 border-2 border-gray-200 border-t-primary-500" />
  </div>
</div>
```

### Empty State
```tsx
<div className="bg-white rounded-lg border border-gray-100 overflow-hidden">
  <div className="p-8 text-center text-sm text-gray-500">
    No data available
  </div>
</div>
```

---

## 10. Cards

### Standard Card
```tsx
<div className="bg-white rounded-lg border border-gray-100 p-4">
  {/* Card content */}
</div>
```

- **Background**: `bg-white`
- **Border**: `border border-gray-100` (very subtle, prefer over shadows)
- **Radius**: `rounded-lg` (8px)
- **Padding**: `p-4` (16px) or `p-6` (24px) for larger cards

---

## 11. Modals

### Modal Overlay
```tsx
<div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
  {/* Modal content */}
</div>
```

### Modal Container
```tsx
<div className="bg-white rounded-lg shadow-large max-w-2xl w-full mx-4">
  {/* Modal header, body, footer */}
</div>
```

- **Max Width**: `max-w-2xl` (672px) for standard modals
- **Shadow**: Use `shadow-large` for depth
- **Radius**: `rounded-lg`

---

## 12. Icons

**Library**: `lucide-react`

### Icon Sizes
- **Navigation**: `size={18}` (18px)
- **Small Icons**: `size={14}` (14px) - Sort indicators
- **Medium Icons**: `size={16}` (16px) - Button icons
- **Large Icons**: `size={20}` (20px) - Page headers

### Icon Colors
- Match parent text color (inherit)
- Navigation icons: `text-gray-700` (inactive), `text-primary-600` (active)

---

## 13. Responsive Breakpoints

Application is **desktop-first**, not heavily optimized for mobile.

Standard Tailwind breakpoints if needed:
- **sm**: 640px
- **md**: 768px
- **lg**: 1024px
- **xl**: 1280px

---

## 14. Scrollbars

### Custom Scrollbar Styling
```css
.scrollbar-thin::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

.scrollbar-thin::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 10px;
}

.scrollbar-thin::-webkit-scrollbar-thumb {
  background: #d1d5db;  /* gray-300 */
  border-radius: 10px;
}

.scrollbar-thin::-webkit-scrollbar-thumb:hover {
  background: #9ca3af;  /* gray-400 */
}
```

Apply `scrollbar-thin` class to scrollable containers.

---

## 15. Focus States

All interactive elements should have consistent focus styles:

```css
focus:outline-none
focus:ring-2
focus:ring-primary-500
focus:ring-offset-1
```

- **Ring Width**: `2px`
- **Ring Color**: `primary-500` (#0088ff)
- **Ring Offset**: `1px`

---

## 16. Transitions

### Standard Transition
```css
transition-colors
```

Applied to:
- Buttons (hover states)
- Navigation items (hover/active states)
- Table rows (hover states)
- Form inputs (focus states)

### Duration
- Default Tailwind duration (150ms) for all transitions

---

## 17. Component Checklist for AI Assistants

When replicating this design system in a new application, ensure:

### Layout
- [ ] Fixed sidebar (w-56, bg-white, border-r)
- [ ] Main content area with ml-56 offset
- [ ] Page background bg-gray-50

### Typography
- [ ] Primarily text-xs (12px) and text-sm (14px)
- [ ] font-medium for labels and emphasis
- [ ] Compact, data-dense text sizing

### Spacing
- [ ] Tight spacing (py-1.5 for most interactive elements)
- [ ] px-3 for input fields
- [ ] px-4 for table cells and cards

### Colors
- [ ] Primary color #0088ff
- [ ] Gray scale from Tailwind defaults
- [ ] Orange-500 for accent/logo
- [ ] Minimal use of shadows, prefer borders

### Components
- [ ] Button: 4 variants (primary, secondary, danger, ghost), 3 sizes
- [ ] Input: text-xs, px-3 py-1.5, rounded-lg, focus:ring-2
- [ ] Table: bg-gray-50 header, text-xs, px-4 py-2 cells
- [ ] Navigation: text-sm, px-2.5 py-1.5, gap-2.5, icon size 18

### Focus & Interaction
- [ ] focus:ring-2 focus:ring-primary-500 on all interactive elements
- [ ] hover:bg-gray-100 for ghost buttons and nav items
- [ ] transition-colors for smooth state changes

---

## 18. Tailwind Configuration

Tailwind CSS v4 theme configuration (from `src/index.css`):

```css
@theme {
  --color-primary-50: #eff6ff;
  --color-primary-100: #dbeafe;
  --color-primary-200: #bfdbfe;
  --color-primary-300: #93c5fd;
  --color-primary-400: #60a5fa;
  --color-primary-500: #0088ff;
  --color-primary-600: #0066cc;
  --color-primary-700: #0055aa;
  --color-primary-800: #004488;
  --color-primary-900: #003366;

  --radius-lg: 8px;
  --radius-xl: 12px;

  --shadow-soft: 0 1px 3px rgba(0, 0, 0, 0.05);
  --shadow-medium: 0 2px 8px rgba(0, 0, 0, 0.08);
  --shadow-large: 0 4px 16px rgba(0, 0, 0, 0.12);
}
```

---

## 19. Quick Reference - Most Common Classes

### Text
- `text-xs` - 12px (labels, inputs, table cells)
- `text-sm` - 14px (buttons, navigation, body text)
- `text-gray-700` - Body text color
- `text-gray-500` - Secondary text
- `font-medium` - Medium weight (500)

### Spacing
- `px-3 py-1.5` - Input fields, medium buttons
- `px-4 py-2` - Table cells
- `gap-2` - Default gap between elements
- `mb-1` - Label to input spacing

### Layout
- `rounded-lg` - 8px radius (default for all components)
- `border border-gray-100` - Card/table borders
- `bg-white` - Component backgrounds
- `bg-gray-50` - Page background

### Colors
- `bg-primary-500` - Primary button background
- `bg-primary-50` - Active navigation background
- `text-primary-600` - Links, active text
- `hover:bg-gray-100` - Hover state

---

## Summary

This design system prioritizes:

1. **Compactness**: Small font sizes (xs, sm), tight spacing (py-1.5)
2. **Data Density**: Maximize information on screen
3. **Cleanliness**: Minimal shadows, subtle borders, flat design
4. **Consistency**: Reusable component patterns
5. **Professional**: Muted gray palette with blue primary color
6. **Accessibility**: Proper focus states, semantic HTML

When creating a new application with this design system, maintain these core principles and use the exact sizing, spacing, and color values documented above.
