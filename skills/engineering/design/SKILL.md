---
name: design
description: Apply Odin's visual design, interaction, animation, and responsive UX principles when explicitly requested.
disable-model-invocation: true
---

## Consistent look:

Define a color scheme first that has enough colors and gaps and sizing styles to cover our needs. Then add reusable components for different button styles, cards, form inputs etc.; base these on the existing design libraries (eg. shadcn, tailwind or others if already present)

## Animations:

- Make sure that our buttons/clickables all have cursor:pointer on hover, scale to .97 on :active.
- Animate things that open / close dynamically from .90 scale, not 0 (only if a scale animation makes sense)
- For items that have tooltips, skip the delay once a tooltip is shown (To do that you’ll need to target the `data-instant` attribute and set the transition duration to `0ms`.)
- For animating things coming/fading/scaling in, use ease-out to make them show up fast. For animating things going out, use ease-in.
- Make animations origin aware with `transform-origin`
- Generally keep animations under 300ms

Example styles for this:

```css
.tooltip {
  transition:
    transform 0.125s ease-out,
    opacity 0.125s ease-out;
  transform-origin: var(--transform-origin);

  &[data-starting-style],
  &[data-ending-style] {
    opacity: 0;
    transform: scale(0.97);
  }

  /** This takes care of disabling subsequent animations */
  &[data-instant] {
    transition-duration: 0ms;
  }
}
```

Also use these custom ease animation curves instead of the default built in ones:
```
/* Strong ease-out for UI interactions */
--ease-out: cubic-bezier(0.23, 1, 0.32, 1);

/* Strong ease-in-out for on-screen movement */
--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);

/* iOS-like drawer curve (from Ionic Framework) */
--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);
```

## General design principles:

- Avoid massive headers, keep them to a reasonable size
- Use at least two different fonts, but not more than 3 - a fancier font for headers, and a basic sans font for regular text
- Avoid overusing pills, make sure they are necessary where you use them
- Make sure the color of selection highlights match the item you're selecting and that their borders fit the borders of the item
- "Delete" buttons should be subtle buttons with a trash icon and no text, confirmation buttons of deletion should spell out "Delete" as text, though
- Make sure the design flows well on Desktop, Tablet and Phone screen sizes. Also make sure that on eg. firefox mobile, the bottom floating url bar doesn't overlap important UI elements
- Make errors or warnings that are automatically fixable or that could offer more detailed info come with buttons that apply the fix / show more details
- Make destructive or dangerous actions for things that can't be trivially recreated come with a confirmation dialog (custom designed! Not the browser built in one)
  - The one exception is if it is undoable but with a hidden menu or extra work (eg. when archiving things, or moving from one collection to another) - in that case show a confirmation toast that holds an "undo" button, rather than asking for confirmation
- If this is an SPA with multiple pages, use a router (tanstack router if no other is indicated or existing) and make sure navigation information is in the URL and browser back/forward works. This also applies to subnavigations, eg. a page with multiple tabs in the page
- Lists of elements (tables, rows etc. - logical lists, not literal html lists) that can be acted upon should have a rightclick context menu with most important actions for quick access
- If there are more than 2 pages on the page, add a quick navigator that opens with cmd+k (or control+k), auto-selects it's input field to search for pages / items that can be opened
- Make sure that (potentially) large lists are virtualized, and make sure that scrolling quickly through virtualized lists works and doesn't blur the list items - users should be able to scroll fast through the list to see what they need
- File/image inputs should allow drag&drop and pasting images from clipboard
- Actions that take some time and have multiple steps (working through a list or completing multiple tasks) should have a progress indicator
- Generally prefer optimistic updating over pessimistic updating
- Prefer showing cohesion / difference through layout, margins and proximity rather than putting borders on everything
- Disabled buttons should have a hover tooltip explaining why they're disabled
- Tooltips should have a custom style that fits the web app's style
- Tooltips should display in the viewport and change their side/location they're showing on if they'd otherwise be cut off

## Performance:

**Only animate transform and opacity**
These properties skip layout and paint, running on the GPU. Animating padding, margin, height, or width triggers all three rendering steps.

This is important for css as well as framer motion:

```
// NOT hardware accelerated (convenient but drops frames under load)
<motion.div animate={{ x: 100 }} />

// Hardware accelerated (stays smooth even when main thread is busy)
<motion.div animate={{ transform: "translateX(100px)" }} />
```

Prefer css animations over js animations.

## Accessibility:

**prefers-reduced-motion**
Animations can cause motion sickness. Reduced motion means fewer and gentler animations, not zero. Keep opacity and color transitions that aid comprehension. Remove movement and position animations.

```
@media (prefers-reduced-motion: reduce) {
  .element {
    animation: fade 0.2s ease;
    /* No transform-based motion */
  }
}
```

```
const shouldReduceMotion = useReducedMotion();
const closedX = shouldReduceMotion ? 0 : '-100%';
```

**Touch device hover states**
```
@media (hover: hover) and (pointer: fine) {
  .element:hover {
    transform: scale(1.05);
  }
}
```

Touch devices trigger hover on tap, causing false positives. Gate hover animations behind this media query.
