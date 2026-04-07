# CopyClip - Complete UI/UX Design Specification for Redesign

## App Identity

**Name:** CopyClip
**Type:** All-in-one productivity mobile app (iOS & Android)
**Design Language:** Material 3 + Glassmorphism
**Theme:** Dark mode primary (with light mode support)
**Base Screen Size:** 390x844 (standard mobile)
**Font:** Outfit (Google Fonts)

---

## Design System

### Color Palette

**Dark Theme (Primary):**
- Background: #111827 (deep navy black)
- Surface: #1F2937 (dark blue-grey)
- Text Primary: #F3F4F6 (off-white)
- Text Secondary: #9CA3AF (muted grey)
- Glass Effect: white at 15% opacity with white border at 25% opacity

**Light Theme:**
- Background: #F9FAFB (near-white)
- Text Primary: #1F2937 (dark blue-grey)
- Text Secondary: #6B7280 (cool grey)

**Feature Accent Colors (each feature has its own identity color):**
- Notes: #FFB74D (warm amber/orange)
- Todos: #66BB6A (fresh green)
- Expenses: #EF5350 (bold red)
- Journal: #42A5F5 (calm blue)
- Calendar: #FF7043 (vibrant orange)
- Events: #E563F7 (purple-pink)
- Clipboard: #AB47BC (rich purple)
- Canvas: #26A69A (teal)
- Social Post: #3F51B5 (deep indigo)

**Dynamic Primary Color:** User-selectable accent color that tints the entire app.

### Visual Style

- **Glassmorphism:** All cards and containers use frosted glass effect (translucent background, subtle blur, thin white border)
- **Rounded Corners:** 16px border radius on cards, 12px on buttons
- **Shadows:** Subtle colored glow shadows matching feature accent colors
- **Animations:** Smooth page transitions, staggered list animations, hero transitions between screens
- **Background:** Animated dynamic backgrounds (floating bubbles, gradient waves, particle effects) behind the glass UI
- **Icons:** Rounded, filled Material icons

---

## Screen-by-Screen Specification

---

### 1. DASHBOARD (Home Screen) - Route: /

**Purpose:** Central hub showing all features at a glance.

**Layout:**
- Top: Greeting text ("Good Morning!") with user's streak count and XP level badge
- Below greeting: Horizontal scrollable "Quick Actions" row (recent items, pinned features)
- Search bar (glass-styled) - tapping opens Global Search
- Feature grid: 3x3 grid of feature cards, each card showing:
  - Feature icon (in its accent color)
  - Feature name
  - Item count badge (e.g., "12 notes", "5 todos")
  - Glass container with subtle color tint matching the feature
- Bottom: Gamification progress bar showing XP to next level
- Floating mascot character (small animated owl/robot) for first-time users

**Interactions:**
- Tap feature card -> Navigate to that feature's list screen
- Tap search bar -> Global Search screen
- Tap XP badge -> XP Detail screen
- Long press feature card -> Quick add new item for that feature

---

### 2. NOTES - Route: /notes

**Purpose:** Rich text note-taking with color coding and tags.

**List Screen Layout:**
- Header: "Notes" title with search icon and sort/filter icon
- Search bar (expandable)
- Masonry grid layout (2 columns) of note cards, each showing:
  - Note title (bold, 1 line)
  - Content preview (2-3 lines, faded at bottom)
  - Color strip on left edge (user-assigned note color)
  - Last updated timestamp
  - Glass card styling
- FAB: "+" button to create new note
- Empty state: Illustration with "No notes yet" message

**Edit Screen Layout (Route: /notes/edit):**
- Top bar: Back arrow, "Save" button, overflow menu (delete, change color, share)
- Title input field (large font, placeholder "Title")
- Rich text editor toolbar: Bold, Italic, Underline, Strikethrough, Bullet list, Numbered list, Heading sizes, Quote block, Code block, Link
- Rich text content area (full remaining screen height)
- Color picker: Bottom sheet with 12+ color options as circles

---

### 3. TODOS - Route: /todos

**Purpose:** Task management with priorities, due dates, recurrence, and reminders.

**List Screen Layout:**
- Header: "Todos" with filter chips (All, Active, Completed, Overdue)
- Category tabs or horizontal filter chips
- Todo list (vertical scrollable), each item showing:
  - Circular checkbox (green when done, strikethrough text)
  - Task text (1-2 lines)
  - Priority indicator: colored dot or badge (Red=High, Orange=Medium, Green=Low)
  - Due date chip (if set), shows "Overdue" in red if past
  - Recurring icon (if repeating)
  - Reminder bell icon (if reminder set)
  - Swipe right: Mark complete, Swipe left: Delete
- FAB: "+" to add new todo
- Progress indicator at top: "8/12 completed today"

**Edit Screen (Route: /todos/edit):**
- Task input field
- Category dropdown/chips
- Priority selector: 3 buttons (Low/Medium/High) with color coding
- Due date picker (calendar popup)
- Reminder toggle with time picker
- Repeat interval: Dropdown (None, Daily, Weekly, Monthly, Yearly, Custom)
- Custom repeat: Day-of-week selector (Mon-Sun toggles)
- Save/Delete buttons

---

### 4. JOURNAL - Route: /journal

**Purpose:** Daily journaling with mood tracking and beautiful page designs.

**List Screen Layout:**
- Header: "Journal" with mood filter and date range picker
- Mood summary bar: Row of mood emoji/icons with counts (Happy: 12, Calm: 8, etc.)
- Journal entries list (vertical), each card showing:
  - Date (large, formatted like "March 15, 2026")
  - Mood emoji and label
  - Title (if set)
  - Content preview (3 lines)
  - Tags as small chips
  - Favorite heart icon
  - Custom page design background tint
- FAB: "+" to create new entry

**Edit Screen (Route: /journal/edit):**
- Mood selector: Horizontal row of 7 mood options (Happy, Sad, Angry, Anxious, Neutral, Excited, Calm) as emoji circles
- Title input
- Rich text editor (same as Notes)
- Tags input: Chip-style with autocomplete from existing tags
- Design picker: Scrollable thumbnail gallery of page templates
- Favorite toggle (heart icon)
- Color picker for custom tint

---

### 5. EXPENSES - Route: /expenses

**Purpose:** Income and expense tracking with charts and category analysis.

**List Screen Layout:**
- Header: "Expenses" with month/year selector
- Summary card at top:
  - Total Income (green), Total Expenses (red), Net Balance
  - Small pie chart or bar chart showing category breakdown
  - Currency selector
- Filter chips: All, Income, Expenses
- Transaction list (grouped by date), each item showing:
  - Category icon (in a colored circle)
  - Title
  - Amount (green if income, red if expense, with currency symbol)
  - Date
  - Glass card with subtle color tint
- FAB: "+" to add transaction

**Edit Screen (Route: /expenses/edit):**
- Amount input (large numeric, with currency prefix)
- Income/Expense toggle (segmented control)
- Title input
- Category selector: Grid of category icons (Food, Transport, Shopping, Bills, Entertainment, Health, Education, Salary, Freelance, Gift, Other)
- Date picker
- Save button

**Charts/Analytics:**
- Monthly bar chart (income vs expenses)
- Category pie chart
- Trend line chart (6-month view)
- All charts use the fl_chart library style (smooth curves, gradient fills)

---

### 6. CLIPBOARD - Route: /clipboard

**Purpose:** Auto-saves clipboard history for quick access and reuse.

**List Screen Layout:**
- Header: "Clipboard" with search and auto-save toggle
- Status indicator: "Auto-save: ON" (green) or "OFF" (red)
- Clipboard items list (vertical, most recent first), each card showing:
  - Content preview (3-4 lines)
  - Timestamp ("2 minutes ago", "Yesterday")
  - Copy button (tap to re-copy to clipboard)
  - Type indicator (text/rich text)
  - Color tag (optional)
  - Swipe to delete
- FAB: "+" to manually add clipboard item

**Edit Screen (Route: /clipboard/edit):**
- Content text area (large, multi-line)
- Color picker
- Save button

---

### 7. CALENDAR - Route: /calendar

**Purpose:** Full event management with visual calendar, recurring events, and reminders.

**Main Calendar Screen Layout:**
- Header: "Calendar" with view toggle (Month/Week) and "All Events" button
- Calendar widget: Monthly grid showing:
  - Day numbers with colored dots indicating events on that day
  - Selected day highlighted with primary color
  - Today highlighted differently
  - Swipe left/right to change month
- Below calendar: "Events for [Selected Date]" section
  - List of events for selected day as styled event cards
  - Activity overlay: Also shows notes, todos, expenses, journal entries created on that day (grouped by type with small icons)
- "Upcoming Events" section: Horizontal scroll of next 3 upcoming event cards
- FAB: "+" to create new event

**Event Card Design:**
- Multiple design patterns available (user-selectable per event):
  - Minimal: Clean white card with colored left border
  - Gradient: Full gradient background matching event color
  - Glassmorphic: Frosted glass with blur
  - Dark: Dark card with neon accent
  - Colorful: Bold solid color background
- Each card shows: Title, time range, location (if any), color dot
- Cards have custom painted decorative elements (curves, dots, lines)

**Event Edit Screen (Route: /calendar/edit):**
- Title input (required)
- Description textarea
- Start Date & Time pickers (side by side)
- End Date & Time pickers (side by side)
- All-day toggle switch
- Location input with icon
- URL input with icon
- Repeat selector: Dropdown (None, Daily, Weekly, Monthly, Yearly)
- Reminder selector: Dropdown (At time, 5 min, 15 min, 30 min, 1 hour, 1 day before)
- Design pattern picker: Horizontal scroll of design thumbnails
- Color picker: Row of color circles
- Save/Delete buttons

**Event Detail Screen (Route: /calendar/detail/:id):**
- Hero-animated event card at top (full width, larger)
- Details section in glass card:
  - Title (large)
  - Date & time range with calendar icon
  - Location with map pin icon (tappable)
  - URL with link icon (tappable, opens browser)
  - Description text
  - Repeat info
  - Reminder info
- Action buttons: Edit (pencil icon), Delete (trash icon), Share (share icon)

**All Events Screen (Route: /calendar/all-events):**
- Timeline-style vertical list of all events
- Sorted by date (newest first)
- Event cards with design patterns
- Tap to open Event Detail

---

### 8. CANVAS - Route: /canvas

**Purpose:** Freehand drawing tool with folders, multi-page support, and PDF export.

**Canvas List Screen:**
- Header: "Canvas" with folder view toggle
- Grid of canvas thumbnails (2 columns)
  - Preview image of the drawing
  - Title below
  - Favorite star icon
- Folder cards (if in folder view)
- FAB: "+" to create new canvas

**Drawing Screen (Route: /canvas/edit):**
- Full-screen canvas area
- Bottom toolbar:
  - Pen tool (multiple pen types)
  - Color picker (horizontal scroll of colors)
  - Stroke width slider
  - Eraser
  - Text tool (tap canvas to place text)
  - Undo/Redo buttons
  - Page navigator (left/right arrows, page indicator dots)
- Top bar: Back, Title, overflow menu (Export PDF, Share, Background color, Delete)
- Gesture support: Pinch to zoom, two-finger pan

**Folder Screen (Route: /canvas/folder):**
- Folder name header
- Grid of canvases in this folder
- Add canvas to folder button

---

### 9. SOCIAL POST COMPOSER - Route: /social-post

**Purpose:** Draft and share posts to 35+ social media platforms.

**Tab Screen Layout:**
- Header: "Social Posts" with tabs (All, Drafts, Favorites)
- Post list, each card showing:
  - Platform icon and name
  - Content preview (2-3 lines)
  - Media thumbnails (if attached, horizontal scroll)
  - Draft badge (if draft)
  - Favorite heart
  - Timestamp
  - Share button
- FAB: "+" to compose new post

**Compose Screen (Route: /social-post/edit):**
- Platform selector at top: Scrollable grid of 35+ platform icons (Instagram, Facebook, Twitter/X, LinkedIn, TikTok, WhatsApp, Telegram, Discord, Slack, Reddit, Pinterest, YouTube, Snapchat, Threads, Mastodon, Bluesky, Notion, GitHub, Medium, etc.)
- Selected platform highlighted with accent color
- Content textarea (large, with character count for platforms with limits)
- Media section: "Add Media" button, shows attached image/video thumbnails with remove option
- Bottom actions: "Save Draft" button, "Share" button (opens platform-specific share)

---

### 10. SETTINGS - Route: /settings

**Purpose:** App configuration, appearance, data management.

**Layout (Scrollable sections):**

**Appearance Section:**
- Theme mode: Light/Dark/System toggle (3 segmented buttons)
- Primary color picker: Grid of color circles
- Background design: Horizontal scroll of background pattern previews (Classic Bubbles, Gradient, Particles, Waves, None)

**Notifications Section:**
- Master notification toggle
- Per-feature notification toggles (Todos, Calendar, Journal, etc.)
- Daily briefing toggle with time picker

**Data Section:**
- Backup data: Button -> Export JSON (shows ad before export)
- Restore data: Button -> Import JSON file picker (shows ad before import)
- Recycle bin: Navigate to deleted items screen
- Clear all data: Danger button with confirmation dialog

**About Section:**
- App version (v1.4.7)
- Privacy policy link
- Send feedback link
- Rate app link

**Premium Section:**
- Current coin balance display
- "Go Premium" card (removes ads, unlocks features)
- Watch ad for coins button

---

### 11. GLOBAL SEARCH - Route: /global-search

**Purpose:** Search across ALL features in one place.

**Layout:**
- Large search input at top (auto-focused)
- Filter chips below: All, Notes, Todos, Journal, Expenses, Clipboard, Calendar, Canvas, Social Posts
- Results list grouped by feature type:
  - Feature icon + name as section header
  - Matching items as compact cards
  - Highlighted matching text
- Recent searches (when search is empty)
- Empty state: "No results found" with illustration

---

### 12. GAMIFICATION / XP DETAIL - Route: /xp-detail

**Purpose:** Visualize user progress, achievements, and streaks.

**Layout:**
- Level badge (large, centered) with current level number
- XP progress bar: "1,250 / 2,000 XP to Level 15"
- Streak section:
  - Current streak: "12 days" with flame icon
  - Best streak: "45 days"
  - Activity heatmap calendar (GitHub-style green squares)
- Medals/Achievements grid:
  - Each medal: Icon + name + description
  - Locked medals shown as greyed out
  - Categories: Notes Master, Todo Champion, Journal Keeper, etc.
- Daily XP breakdown: Bar chart showing XP earned per feature today
- History: Last 7 days XP trend line

---

### 13. PREMIUM - Route: /premium

**Purpose:** Coin shop, premium subscription, ad management.

**Layout:**
- Coin balance (large, top center, with coin icon)
- "Premium Benefits" card:
  - No ads
  - Unlimited backups
  - Exclusive themes
  - Priority features
- "Get Premium" button (costs X coins for 30 days)
- "Earn Coins" section:
  - Watch rewarded ad: "+10 coins" button
  - Daily check-in bonus
  - Complete tasks for XP and coins
- Transaction history list

---

### 14. RECYCLE BIN - Route: /settings/recycle-bin

**Purpose:** Recover deleted items from any feature.

**Layout:**
- Header: "Recycle Bin" with "Empty All" button
- Filter chips by feature type
- List of deleted items, each showing:
  - Feature icon + type label
  - Item title/preview
  - Deleted date ("Deleted 3 days ago")
  - Restore button (undo icon)
  - Permanent delete button (trash icon)

---

## Navigation Flow Summary

```
App Launch
  |
  v
Dashboard (/)
  |
  +-- Notes (/notes) --> Note Edit (/notes/edit)
  |
  +-- Todos (/todos) --> Todo Edit (/todos/edit)
  |
  +-- Journal (/journal) --> Journal Edit (/journal/edit)
  |
  +-- Expenses (/expenses) --> Expense Edit (/expenses/edit)
  |
  +-- Clipboard (/clipboard) --> Clipboard Edit (/clipboard/edit)
  |
  +-- Calendar (/calendar)
  |     +-- Event Edit (/calendar/edit)
  |     +-- Event Detail (/calendar/detail/:id) --> Event Edit
  |     +-- All Events (/calendar/all-events) --> Event Detail
  |
  +-- Canvas (/canvas)
  |     +-- Canvas Edit (/canvas/edit)
  |     +-- Canvas Folder (/canvas/folder)
  |
  +-- Social Post (/social-post) --> Compose (/social-post/edit)
  |
  +-- Global Search (/global-search) --> Any feature item
  |
  +-- XP Detail (/xp-detail)
  |
  +-- Settings (/settings)
        +-- Recycle Bin (/settings/recycle-bin)
        +-- Privacy Policy (/settings/privacy-policy)
        +-- Feedback (/settings/feedback)
        +-- Background Picker (/settings/background-picker)
        +-- Premium (/premium)
```

---

## Key UX Patterns (Apply Consistently)

1. **Glass Cards Everywhere:** Every list item, detail card, and input container uses glassmorphism (translucent background, blur, thin border)
2. **Feature Color Coding:** Each feature consistently uses its accent color for icons, highlights, and subtle tints
3. **Animated Transitions:** Hero animations between list items and detail views, staggered list entry animations, smooth page transitions
4. **Empty States:** Every list screen has a friendly empty state with an illustration and action prompt
5. **Swipe Actions:** List items support swipe gestures (delete, complete, archive)
6. **Pull to Refresh:** All list screens support pull-to-refresh
7. **FAB Pattern:** Every list screen has a floating action button for creating new items
8. **Search Pattern:** Every feature has search capability (either inline or via global search)
9. **Soft Delete:** Items go to recycle bin first, not permanently deleted
10. **Responsive Text:** All text scales appropriately for different screen sizes
11. **Dark Mode First:** Design primarily for dark mode, ensure light mode is equally polished
12. **Bottom Sheets:** Pickers, filters, and secondary actions use bottom sheets (not new screens)
13. **Haptic Feedback:** Subtle haptics on toggle switches, completions, and long presses
14. **Micro-animations:** Small delightful animations (checkbox tick, delete swoosh, XP gain sparkle)

---

## Technical Notes for Designers

- The app is offline-first with no cloud sync (no loading spinners for data, instant local reads)
- All data persists locally - design for instant state changes
- Notifications appear as system notifications, not in-app banners
- Home screen widgets exist for iOS and Android (small glanceable cards)
- The app supports 35+ social platforms for sharing - design the platform picker to be scannable
- Canvas drawing needs to be performant - minimize overlay UI elements during drawing mode
- The calendar uses table_calendar style - standard month grid with dot indicators
