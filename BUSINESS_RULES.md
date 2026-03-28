# IBVN — Business Rules & Product Specifications

---

## 1. Product Overview

**IBVN (Iglesia Vida Nueva)** is a church media app that delivers live broadcasts, sermon series, podcasts, and recommended content to congregants. It also serves as an information hub for campus locations and pastoral staff.

---

## 2. Content Domain Model

**Playlist** — A collection of videos with: title, description, publication date, thumbnail image, and a last-updated timestamp.

**Video** — A single media item within a playlist: title, description, publication date, thumbnail, and position within its playlist.

**Campus** — A physical church location: name, address, country, coordinates, phone, WhatsApp number, and an assigned pastor (name, lastname, photo).

**Pastor** — A church leader: name, lastname, role, and photo.

**Live Broadcast** — A single broadcast: video ID, title, thumbnail, description, publication date, live state, and an "is live" flag.

---

## 3. Content Classification System

All playlists are classified using **hashtags** embedded in their title or description. Classification follows an **include/exclude tag model**:

- A playlist **matches** a category if it contains **at least one include tag** (or the category has no include tags) **AND** contains **none of the exclude tags**.
- Tag matching is **case-insensitive** and **diacritics-insensitive** (e.g., "Recomendada" matches "recomendadá").

| Category | Include Tags | Exclude Tags |
|---|---|---|
| Series | *(none — all by default)* | `#Podcast`, `#ElRetoDeHoy` |
| Podcast | `#Podcast`, `#ElRetoDeHoy` | *(none)* |
| Recommended (Past Series) | `#Recomendada` | `#RecomendadaDomingo`, `#RecomendadaNDVN` |
| Recommended Sunday | `#RecomendadaDomingo` | *(none)* |
| Recommended Noches de Vida Nueva | `#RecomendadaNDVN` | *(none)* |
| Noches de Viernes | `#NDV` | *(none)* |
| El Reto De Hoy | `#ElRetoDeHoy` | *(none)* |

**Sub-filters within tabs:**

- **Podcast tab** has two views: "All Podcasts" (has `#Podcast` but NOT `#ElRetoDeHoy`) and "El Reto De Hoy" (only `#ElRetoDeHoy`).
- **Series tab** has two views: "All Series" (no sub-filter) and "Noches de Vida Nueva" (only `#NDV`).

---

## 4. Navigation Structure

The app has **4 main tabs**:

| Tab | Label | Content |
|---|---|---|
| 1 | Inicio (Home) | Live broadcast + quick links |
| 2 | Series | Filtered playlists (series content) |
| 3 | Podcast | Filtered playlists (podcast content) |
| 4 | Recomendadas | Recommended content in carousels + past series list |

**Settings** is accessible only after authenticated sign-in (admin function).

---

## 5. Live Broadcast Rules

A single "current broadcast" is tracked at all times. It exists in one of three states:

| State | Condition | Display Label |
|---|---|---|
| **Live** | Broadcast is actively streaming | "EN VIVO" |
| **Upcoming** | Broadcast is scheduled but not yet started | "Próximo en vivo" |
| **Last** | No active/upcoming broadcast; shows last completed | "Última transmisión" |

**Sync priority** when refreshing: the system searches for an **upcoming** broadcast first, then **live**, then **completed** (most recent). The first match wins.

**Real-time updates**: The live broadcast updates automatically in real time without user intervention.

---

## 6. Quick Links (Home Tab)

The home screen provides four action buttons:

| Button | Action |
|---|---|
| WhatsApp | Opens WhatsApp to phone `25228106` with preset message |
| + Vida Nueva | Opens `linktr.ee/ibvidanueva` |
| Campus | Opens `ibvn.org` |
| Formas de donar | Opens `donaciones.ibvn.org` |

---

## 7. Playlist Display & Sorting

- Default sort: **most recent first** (by publication date, descending).
- Alternative sort: **alphabetical A–Z** by title.
- **Search**: User can search playlists by typing keywords. All tokens must match (AND logic), using prefix matching against title + description. Normalized for case and diacritics.

---

## 8. Video Display & Preview Mode

- Videos are fetched in pages of **50 items max**, with automatic pagination until all videos are loaded.
- **Preview mode**: If a playlist's title or description contains `#Preview`, videos are shown as navigable links (tap to open full view). Otherwise, videos are **embedded inline** directly in the list.
- **Video search**: Case-insensitive substring match on title OR description.
- **Video info shown**: Title, publication date (YYYY-MM-DD), embedded player. Description shown only in detail/live views.

---

## 9. Recommended Content

The Recommended tab organizes content into three sections displayed as **horizontal carousels**:

1. **Sunday Playlists** — tagged `#RecomendadaDomingo`
2. **Noches de Vida Nueva** — tagged `#RecomendadaNDVN`
3. **Past Series** — tagged `#Recomendada` (excluding the above two)

Below the carousels, an expandable **"Series Pasadas"** section lists the Past Series playlists in full.

---

## 10. Campus Information

- Multiple campuses displayed with **previous/next navigation** (carousel).
- Each campus shows: name, address, country, map pin, phone number, WhatsApp, and assigned pastor (name, photo).
- **Phone tap** → copies number to clipboard.
- **WhatsApp tap** → opens WhatsApp with preset message: *"Los visito desde la App"*.
- A **general pastoral leadership section** displays all pastors with their roles.
- Campus and pastor data are fetched once on screen load.

---

## 11. Data Freshness & Caching

- **Cache validity rule**: Cached playlist data is valid only if the cache timestamp is **equal to or newer than** the playlist's last-updated timestamp in the cloud. Any cloud update invalidates the cache.
- **Load priority**: Memory cache → Disk cache → Network fetch.
- **Full cache clear** occurs after any admin sync operation.
- **Playlists** update in real time via cloud listeners — UI refreshes automatically when upstream data changes.

---

## 12. Authentication & Admin Access

- **Sign-in requires**: valid email (must contain `@` and `.`) and non-empty password.
- **Email verification is mandatory**: Unverified users see a warning with an option to resend the verification email. Resending signs the user out.
- **Settings (admin panel)** is only accessible after verified sign-in.

---

## 13. Admin Sync Operations

Two sync functions available in Settings:

### Sync Live

1. Search for upcoming broadcasts → if found, save as current live.
2. If none, search for active live broadcasts → save if found.
3. If none, search for completed broadcasts → save most recent.
4. Provides status feedback throughout.

### Sync Playlists

1. Download all playlists from the YouTube channel (paginated).
2. Compare with existing cloud data: create new, update existing, **delete playlists that no longer exist on YouTube**.
3. Clear all local caches.
4. Notify the app to refresh all views.
5. Displays count of playlists downloaded as feedback.

---

## 14. Error Handling & User Feedback

| Scenario | User-Facing Message |
|---|---|
| Cloud data fetch failure | "No se ha logrado recuperar datos" (Could not retrieve data) |
| Network/sync error | Error description from the system |
| Form validation failure | Inline message below the form |
| Unverified email | Warning alert with resend option |

**Alert severity levels**: Info, Warning, Error.
**Default dismiss button**: "Entendido" (Understood).

---

## 15. App-Wide Constraints

- **Dark mode only** — the app enforces dark theme regardless of device settings.
- **Language**: Spanish (all UI labels, messages, and content).
- **Splash screen**: 2-second animated fade-in on launch.
- **YouTube channel**: Single source channel.
- **Font**: DM Sans throughout.
