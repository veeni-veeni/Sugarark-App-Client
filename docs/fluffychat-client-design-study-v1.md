---
schema: sugarark-app-client-review/v1
map_version: v5.2
review_level: L4-client-architecture-research
reviewer: codex
status: open
date: 2026-05-13
scope:
  - FluffyChat client UX and Flutter architecture lessons
  - SugarArk User App chat and messaging experience
  - Talkcore integration boundary for user-facing app
non_goals:
  - Copying FluffyChat source code
  - Forking FluffyChat
  - Adopting Matrix protocol
  - Changing current Flutter code now
sources:
  - https://github.com/krille-chan/fluffychat
  - https://fluffy.chat/
  - https://fluffy.chat/fy/faq/
---

# Codex Study: FluffyChat Client Design Lessons for SugarArk User App

## 1. Decision

FluffyChat is worth studying for `Sugarark-App-Client`, but only as a Flutter IM client UX and layering reference.

Do not directly use or copy FluffyChat source code.

Reasons:

- FluffyChat is a Matrix client; SugarArk User App uses SugarArk business APIs plus Talkcore IM.
- FluffyChat is AGPL licensed; direct reuse/fork is not the right default for this commercial client.
- SugarArk User App is a dating/social product with advisor-assisted matching, not a generic Matrix messenger.

The correct adoption:

```text
Learn chat UX and Flutter layering.
Do not copy source code.
Do not adopt Matrix.
Build a SugarArk/Talkcore-native user app.
```

## 2. What Applies to SugarArk User App

SugarArk User App needs mature chat UX, but its messaging experience is shaped by business flows:

- user ↔ advisor 1:1 chat
- advisor-recommended baby/daddy rich cards
- mutual match three-person introduction group
- official announcement channel
- privacy-gated contact information
- membership-level dependent UI

Useful FluffyChat lessons:

| Area | Learn from FluffyChat | User App adaptation |
|---|---|---|
| Conversation list | Last-message preview, unread, pinned/muted, draft-like state | Messages tab with advisor chats, intro groups, official channel |
| Timeline | Stable scroll, day separators, sender grouping, read marker | Talkcore `seq` based history, preserving scroll across route changes |
| Local cache | Fast reopen and reconnect tolerance | Cache recent conversations/messages without persisting sensitive PII/media raw data |
| Multi-device | State changes visible across devices | App/Web/TG Mini App should share same `im_user_id` state |
| Media preview | Image/file/audio states | Use SugarArk authenticated media URLs; no direct `/uploads/` exposure |
| Reactions/typing | Lightweight social feedback | Use only when Talkcore supports it and it fits dating context |
| Theme/i18n | Polished user-facing settings | Mobile-first theme, font scale, language hooks |
| Mobile/desktop adaptation | Responsive patterns | V1 is iOS/Android only; keep tablet-friendly patterns, not desktop-first shell |

## 3. What Does Not Apply

Do not import these FluffyChat/Matrix assumptions:

- Matrix homeserver login.
- Matrix room/event/sync model.
- Matrix E2EE/key backup/cross-signing.
- Federation.
- Direct FluffyChat widgets/components/source code.
- Generic public chat features that conflict with SugarArk privacy and advisor-led matching.

SugarArk User App flow should remain:

```text
SugarArk user auth
  -> user JWT in secure storage
  -> SugarArk backend issues Talkcore IM token
  -> Talkcore WebSocket for IM
  -> SugarArk UI renders business-safe chat state
```

The app must never receive Talkcore `app_secret` or Internal JWT.

## 4. Existing Project Structure Fit

Current repo already has a useful foundation:

```text
lib/
  core/
    api/
    auth/
    routing/
    talkcore/
    theme/
  features/
    auth/
    chat/
    home/
    notifications/
    profile/
    recommendations/
  shared/
```

Recommended refinement as chat grows:

```text
lib/
  core/
    talkcore/
      client/              # WS client, protocol decoder, auth.connect
      sync/                # reconnect, sync.pull, cursor repair
      local_cache/         # conversations/messages/dialog state
      event_router.dart    # raw frame -> typed events
    api/
    auth/
    routing/
    theme/
  features/
    chat/
      conversation_list/
      chat_timeline/
      composer/
      media_preview/
      rich_cards/          # advisor-recommended profile cards
      official_channel/
      intro_group/
  shared/
    widgets/
      message_bubbles/
      adaptive_shell/
```

Rules:

- `features/chat` should not parse raw Talkcore WebSocket JSON.
- `core/talkcore` owns protocol decoding, reconnect, subscriptions, sync, and cache hydration.
- SugarArk business data stays in API/domain models outside raw IM frame handling.
- Contact privacy filtering must come from backend/Talkcore-safe responses, not client-side hiding alone.

## 5. User App Messaging UX Requirements

### P1 Chat UX

- Conversation list with unread count and last message preview.
- Separate visual treatment for advisor 1:1, mutual match groups, and official channel.
- Stable chat timeline with pagination and preserved scroll position.
- Day separators and sender grouping.
- Message pending/failed/retry states.
- Reconnect and sync-in-progress indicators.
- Media/file preview with safe loading/error states.
- Rich baby/daddy recommendation card rendering.
- Read marker / last-read position when Talkcore provides it.
- Typing indicator only as ephemeral UI.

### P1 Privacy UX

- Do not display phone/wechat/contact fields unless backend says visible.
- Do not persist sensitive profile/contact fields in local durable cache.
- Do not cache raw video verification files locally.
- Media must load through authenticated URLs or app-safe cached copies.
- If a message contains unavailable/expired media, show a safe fallback instead of leaking raw URL details.

### P2 Chat UX

- Search UI after Talkcore search baseline exists.
- Saved/favorite messages after Talkcore supports them.
- Theme and font-size settings.
- Language/i18n foundation.
- Tablet-friendly two-pane layout if later needed.
- Push deep link into specific conversation after push strategy is finalized.

## 6. Event Flow

Recommended IM event flow:

```text
Talkcore WSS frame
  -> core/talkcore decoder
  -> category router
  -> message/conversation/presence/sync manager
  -> local cache
  -> chat feature state
  -> Flutter UI
```

Recommended business event flow:

```text
SugarArk API response / push deep link
  -> profile/recommendation/membership domain state
  -> chat rich card / profile / recommendation UI
```

Do not merge business domain state and raw Talkcore protocol state into one untyped stream.

## 7. Relationship With Staff Client

Likely reusable from `sugarark-staff-client`:

- Talkcore protocol decoder.
- WebSocket reconnect and auth refresh logic.
- `sync.pull` and history hydration.
- local cache primitives.
- message model and message bubble primitives.
- media preview primitives.
- theme tokens.

Likely not reusable:

- staff queue/workstation shell.
- customer context panel.
- advisor internal notes.
- escalation actions.
- desktop-first three-pane CRM layout.

This matches the existing lazy extraction rule:

```text
Copy/adapt first.
Extract shared package only after overlap is real and stable.
```

## 8. Suggested Claude Work

No immediate code change is required from this document.

When User App chat work resumes, Claude should:

1. Write a short chat architecture note before expanding `features/chat`.
2. Keep raw Talkcore frame parsing inside `core/talkcore`.
3. Define local cache boundaries before timeline pagination grows.
4. Keep rich recommendation cards as SugarArk business payloads, not generic IM protocol assumptions.
5. Treat FluffyChat as UX reference only, not source material.

## 9. Bottom Line

FluffyChat is useful for SugarArk User App because it shows what mature Flutter chat UX feels like.

The valuable lessons are:

```text
conversation list polish
timeline stability
local cache discipline
media preview states
multi-device UX
clear separation between protocol layer and UI
```

The non-negotiable boundary:

```text
No FluffyChat source reuse.
No Matrix adoption.
No client-side-only privacy filtering.
SugarArk User App must remain SugarArk + Talkcore native.
```
