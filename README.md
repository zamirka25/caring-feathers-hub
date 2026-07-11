# Caring Feathers Finance Hub

Bill and budget manager — installable web app (PWA).

**Live app:** https://zamirka25.github.io/caring-feathers-hub/

## Features
- Bills organised by calendar month, with per-month totals (total / paid / outstanding)
- Calendar view of due dates
- Automatic scheduling of the next bill when a recurring bill is paid
- Monthly budgets per home with progress tracking
- Management reports: spend by home / category, budget vs actual, 12-month trend, print-to-PDF, CSV export, copy-to-WhatsApp summary
- Reminders for overdue and due-soon bills (notifications on app open)
- Installable on phone and desktop (PWA), works offline
- JSON backup export / import

## Notes
- v2.0: data lives in a shared cloud database (Supabase) with team login — everyone sees changes live.
- Team members are managed in the Supabase dashboard (Authentication → Users).
- Use **Settings → Load demo data** to explore the features with example figures (affects all users).
- Export a JSON backup regularly from Settings.

Built July 2026.
